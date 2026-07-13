import 'package:exp_intern/features/dynamic_steps/data/model/dynamic_step_model.dart';
import 'package:exp_intern/features/dynamic_steps/domain/entity/dynamic_step_entity.dart';
import 'package:exp_intern/features/hourly_contract/presentation/cubit/hourly_contract_cubit.dart';
import 'package:exp_intern/features/hourly_contract/presentation/screens/contract_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exp_intern/core/di/service_locator.dart';
import 'package:exp_intern/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:exp_intern/features/auth/presentation/screen/forget_screen.dart';
import 'package:exp_intern/features/auth/presentation/screen/login_screen.dart';
import 'package:exp_intern/features/auth/presentation/screen/register_screen.dart';
import '../../features/addresses/presentation/cubit/addresses_cubit.dart';
import '../../features/addresses/presentation/screen/saved_addresses_screen.dart';
import '../../features/auth/presentation/screen/new_password_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/hourly_contract/presentation/screens/hourly_select_package_screen.dart';
import '../../features/hourly_contract/presentation/screens/success_contract_screen.dart';
import '../../features/resource_groub/presentation/cubit/resource_group_cubit.dart';
import '../../features/service/presentation/cubit/service_cubit.dart';
import '../../features/service/presentation/screen/choose_service_screen.dart';
import '../../features/hourly_contract/presentation/screens/selected_package_screen.dart';

class RoutesManager {
  static const String logIn = '/logIn';
  static const String register = '/register';
  static const String forgetPassword = '/forgetPassword';
  static const String newPassword = '/newPassword';
  static const String home = '/home';
  static const String savedAddresses = '/savedAddresses';
  static const String chooseService = '/chooseService';
  static const String selectPackage = 'FixedPackage';
  static const String hourlySelectPackage = 'HourlySelectPackage';
  static const String HourlyPackagePromotion = 'HourlyPackagePromotion';
  static const String HourlyCreatedSuccess = 'HourlyCreatedSuccess';

  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
    case logIn:
    return MaterialPageRoute(
    builder: (_) => BlocProvider(
    create: (context) => sl<AuthCubit>(),
    child: const LoginScreen(),
    ),
    );
    case register:
    return MaterialPageRoute(builder: (_) => const RegisterScreen());

    case forgetPassword:
    return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
    case newPassword:
    return MaterialPageRoute(
    builder: (_) => const NewPasswordScreen(),
    settings: settings,
    );
    case home:
    return MaterialPageRoute(builder: (_) => const HomeScreen());
    case savedAddresses:
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
    providers: [
    BlocProvider(create: (context) => sl<AddressesCubit>()),
    ],
    child: SavedAddressesScreen(
    serviceId: args['serviceId'] as String,
    stepEntity: args['firstStepEntity']as DynamicStepEntity ,
    ),
    ),
    );
    case chooseService:
    final serviceType = settings.arguments as int;

    return MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
    providers: [BlocProvider(create: (context) => sl<ServiceCubit>())],
    child: ChooseServiceScreen(serviceType: serviceType),
    ),
    );
    case selectPackage:
    final args = settings.arguments as Map<String, dynamic>;
    final serviceId = args['serviceId'] as String;
    final stepEntity = args['stepEntity'] as DynamicStepEntity;
    return MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
    providers: [
    BlocProvider(create: (context) => sl<HourlyContractCubit>()),
    BlocProvider(create: (context) => sl<ResourceGroupCubit>()),
    ],

    child: SelectPackageScreen(serviceId: serviceId, stepEntity: stepEntity,),
    ),
    );
    case hourlySelectPackage:
    final args = settings.arguments as Map<String, dynamic>;
    final serviceId = args['serviceId'] as String;
    final stepId = args['stepId'] as String;
    final stepEntity = args['stepEntity'] as DynamicStepEntity;

    return MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
    providers: [
    BlocProvider(create: (context) => sl<HourlyContractCubit>()),
    BlocProvider(create: (context) => sl<ResourceGroupCubit>()),
    ],
    child: HourlySelectPackage(serviceId: serviceId, stepId: stepId,stepEntity: stepEntity,),
    ),
    );
    case HourlyPackagePromotion:
    final args = settings.arguments as Map<String, dynamic>;
    final serviceId = args['serviceId'] as String;
    final cubit = args['cubit'] as HourlyContractCubit;
    return MaterialPageRoute(
    builder: (_) => BlocProvider.value(
    value: cubit,
    child: const ContractDetailsScreen(),
    ),
    settings: settings,
    );
    case HourlyCreatedSuccess :
    final args = settings.arguments as Map<String, dynamic>;

    final stepEntity = args['stepEntity'] as DynamicStepEntity;

    return MaterialPageRoute(
    builder: (_) => BlocProvider( create: (context) => sl<HourlyContractCubit>(),

    child: SuccessContractScreen(stepEntity: stepEntity,)),
    settings: settings,
    );
    }
    return null;
  }
}
