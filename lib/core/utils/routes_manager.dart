import 'package:exp_intern/features/auth/presentation/screen/forget_screen.dart';
import 'package:exp_intern/features/auth/presentation/screen/login_screen.dart';
import 'package:exp_intern/features/auth/presentation/screen/register_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/screen/new_password_screen.dart';

class RoutesManager {
  static const String logIn = '/logIn';
  static const String register = '/register';
  static const String forgetPassword = '/forgetPassword';
  static const String newPassword = '/newPassword';




  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
      case logIn:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        case forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case newPassword:
        return MaterialPageRoute(

          builder: (_) => const NewPasswordScreen(),
          settings: settings,
        );
    }
    return null;
  }
}
