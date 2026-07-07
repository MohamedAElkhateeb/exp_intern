// features/auth/presentation/screens/login_screen.dart
import 'package:exp_intern/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:exp_intern/features/auth/presentation/cubit/auth_state.dart';
import 'package:exp_intern/features/auth/presentation/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/auth_question_row.dart';
import '../widgets/language_switch_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? ColorsManager.darkBackground
          : ColorsManager.white,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // إخفاء أي سناك بار ظاهر قبل الانتقال
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              // إظهار رسالة ترحيبية للمستخدم بالاسم الراجع من الـ Entity النظيفة
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    LocaleKeys.login_success.tr(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              // الانتقال إلى الشاشة الرئيسية ومسح شاشات الـ Auth من الـ Stack
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesManager.home,
                    (route) => false,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              final failure = state.failure;

              // 🎨 شكل مختلف حسب نوع الخطأ
              if (failure is NetworkFailure) {
                // 📶 خطأ شبكة - لون برتقالي
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 20.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            failure.message ?? LocaleKeys.no_internet_error.tr(),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.orange.shade700,
                    duration: const Duration(seconds: 5),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (failure is ServerFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            failure.message ?? LocaleKeys.server_internal_error.tr(),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red.shade700,
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.message ?? LocaleKeys.unexpected_error.tr()),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: formKey,
              child: Column(
                key: ValueKey(context.locale.languageCode),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  CustomLogo(fontSize: 50.sp),
                  SizedBox(height: 60.h),
                  Text(
                    LocaleKeys.login_title.tr(),
                    style: LightAppStyle.title.copyWith(
                      color: isDarkMode
                          ? ColorsManager.white
                          : ColorsManager.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    LocaleKeys.login_subtitle.tr(),
                    style: LightAppStyle.subtitle.copyWith(
                      color: isDarkMode
                          ? ColorsManager.white70
                          : ColorsManager.greyText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    label: LocaleKeys.phone_label.tr(),
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    validator: (value) => Validators.phone(value),
                  ),
                  SizedBox(height: 24.h),
                  CustomTextField(
                    label: LocaleKeys.password_label.tr(),
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) => Validators.password(value),
                  ),
                  SizedBox(height: 16.h),
                  AuthQuestionRow(
                    question: LocaleKeys.forgot_password_question.tr(),
                    actionText: LocaleKeys.reset_password.tr(),
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesManager.forgetPassword,
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CustomElevatedButton(
                        text: LocaleKeys.login_button.tr(),
                        onPressed: () {
                          final state = context.read<AuthCubit>().state;

                          if (state is AuthLoading) return; // 🔥 يمنع الضغط المتكرر

                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().loginUser(
                              userName: phoneController.text.trim(),
                              password: passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),

                  SizedBox(height: 24.h),
                  AuthQuestionRow(
                    question: LocaleKeys.no_account_question.tr(),
                    actionText: ColorsManager.white == ColorsManager.white ? LocaleKeys.create_account.tr() : '',
                    onActionTap: () {
                      Navigator.pushNamed(context, RoutesManager.register);
                    },
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      LocaleKeys.skip_now.tr(),
                      style: LightAppStyle.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? ColorsManager.white80
                            : ColorsManager.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  const LanguageSwitchRow(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}