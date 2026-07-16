// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/addresses/data/data_source/addresses_remote_data_source.dart'
    as _i737;
import '../../features/addresses/data/repositories/addresses_repository_impl.dart'
    as _i837;
import '../../features/addresses/domain/repositories/addresses_repository.dart'
    as _i1;
import '../../features/addresses/presentation/cubit/addresses_cubit.dart'
    as _i3;
import '../../features/auth/data/data_source/auth_remote_data_source.dart'
    as _i182;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/dynamic_steps/data/data_source/dynamic_steps_data_source.dart'
    as _i1014;
import '../../features/dynamic_steps/data/repositories/dynamic_steps_repository_impl.dart'
    as _i580;
import '../../features/dynamic_steps/domain/repositories/steps_repository.dart'
    as _i996;
import '../../features/dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart'
    as _i389;
import '../../features/hourly_contract/data/data_source/hourly_contract_remote_data_source.dart'
    as _i273;
import '../../features/hourly_contract/data/repositories/hourly_contract_repository_impl.dart'
    as _i572;
import '../../features/hourly_contract/domain/repositories/hourly_contract_repository.dart'
    as _i488;
import '../../features/hourly_contract/presentation/cubit/hourly_contract_cubit.dart'
    as _i769;
import '../../features/payment/data/datasource/payment_remote_data_source.dart'
    as _i726;
import '../../features/payment/data/repositories/payment_repository_impl.dart'
    as _i265;
import '../../features/payment/domain/repositories/payment_repository.dart'
    as _i639;
import '../../features/payment/presentation/cubit/payment_cubit.dart' as _i513;
import '../../features/resource_groub/data/data_source/nationality_remote_data_source.dart'
    as _i9;
import '../../features/resource_groub/data/repositories/nationality_repository_impl.dart'
    as _i1023;
import '../../features/resource_groub/domain/repositories/nationality_repository.dart'
    as _i571;
import '../../features/resource_groub/presentation/cubit/resource_group_cubit.dart'
    as _i101;
import '../../features/service/data/data_source/service_remote_data_source.dart'
    as _i670;
import '../../features/service/data/repositories/service_repository_impl.dart'
    as _i953;
import '../../features/service/domain/repositories/service_repository.dart'
    as _i1069;
import '../../features/service/presentation/cubit/service_cubit.dart' as _i127;
import '../network/api_service.dart' as _i921;
import '../storage/token_storage.dart' as _i973;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i973.TokenStorage>(() => _i973.TokenStorage());
    gh.lazySingleton<_i921.ApiService>(
      () => _i921.ApiService(gh<_i973.TokenStorage>()),
    );
    gh.lazySingleton<_i737.AddressesRemoteDataSource>(
      () => _i737.AddressesRemoteDataSource(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i182.AuthRemoteDataSource>(
      () => _i182.AuthRemoteDataSource(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i1014.DynamicStepsDataSource>(
      () => _i1014.DynamicStepsDataSource(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i273.HourlyContractRemoteDataSource>(
      () => _i273.HourlyContractRemoteDataSource(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i726.PaymentDataSource>(
      () => _i726.PaymentDataSource(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i670.ServiceRemoteDataSource>(
      () => _i670.ServiceRemoteDataSource(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i9.NationalityRemoteDataSource>(
      () => _i9.NationalityRemoteDataSourceImpl(gh<_i921.ApiService>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i182.AuthRemoteDataSource>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i571.NationalityRepository>(
      () => _i1023.NationalityRepositoryImpl(
        gh<_i9.NationalityRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i996.DynamicStepsRepository>(
      () =>
          _i580.DynamicStepsRepositoryImpl(gh<_i1014.DynamicStepsDataSource>()),
    );
    gh.lazySingleton<_i488.HourlyContractRepository>(
      () => _i572.HourlyContractRepositoryImpl(
        gh<_i273.HourlyContractRemoteDataSource>(),
      ),
    );
    gh.factory<_i389.DynamicStepsCubit>(
      () => _i389.DynamicStepsCubit(
        gh<_i996.DynamicStepsRepository>(),
        gh<_i921.ApiService>(),
      ),
    );
    gh.factory<_i769.HourlyContractCubit>(
      () => _i769.HourlyContractCubit(gh<_i488.HourlyContractRepository>()),
    );
    gh.lazySingleton<_i1069.ServiceRepository>(
      () => _i953.ServiceRepositoryImpl(gh<_i670.ServiceRemoteDataSource>()),
    );
    gh.lazySingleton<_i639.PaymentRepository>(
      () => _i265.PaymentRepositoryImpl(gh<_i726.PaymentDataSource>()),
    );
    gh.lazySingleton<_i1.AddressesRepository>(
      () =>
          _i837.AddressesRepositoryImpl(gh<_i737.AddressesRemoteDataSource>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i127.ServiceCubit>(
      () => _i127.ServiceCubit(gh<_i1069.ServiceRepository>()),
    );
    gh.factory<_i101.ResourceGroupCubit>(
      () => _i101.ResourceGroupCubit(gh<_i571.NationalityRepository>()),
    );
    gh.factory<_i3.AddressesCubit>(
      () => _i3.AddressesCubit(
        gh<_i1.AddressesRepository>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.factory<_i513.PaymentCubit>(
      () => _i513.PaymentCubit(gh<_i639.PaymentRepository>()),
    );
    return this;
  }
}
