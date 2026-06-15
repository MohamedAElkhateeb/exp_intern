import 'package:get_it/get_it.dart';
import 'package:exp_intern/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:exp_intern/features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/domin/repositories/auth_repository.dart';
import '../../features/auth/domin/use_cases/login_use_case.dart';
import '../network/api_service.dart';

final GetIt sl = GetIt.instance; // sl اختصار لـ Service Locator

Future<void> setupServiceLocator() async {
  // 1. Core Services (الخدمات الأساسية)
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // 2. Data Sources (مصادر البيانات)
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl<ApiService>()));

  // 3. Repositories (المستودعات)
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));

  // 4. Use Cases (حالات الاستخدام)
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));

  // 5. Cubits / Blocs (المتحكمات - تسجل كـ Factory لأنها تُغلق وتُنشأ مجدداً مع الشاشات)
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));
}