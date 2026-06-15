// features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/auth_question_row.dart';
import '../widgets/custom_logo.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController();
    final middleNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : ColorsManager.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
        foregroundColor: isDarkMode ? ColorsManager.white : ColorsManager.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomLogo(fontSize: 50.sp),
                      SizedBox(height: 30.h),
                      Text(
                        LocaleKeys.register_title.tr(),
                        style: LightAppStyle.title.copyWith(
                          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        LocaleKeys.register_subtitle.tr(),
                        style: LightAppStyle.subtitle.copyWith(
                          color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      CustomTextField(
                        label: LocaleKeys.first_name.tr(),
                        controller: firstNameController,
                        validator: (value) => Validators.name(value, fieldName: LocaleKeys.first_name.tr()),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LocaleKeys.middle_name.tr(),
                        controller: middleNameController,
                        validator: Validators.optional,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LocaleKeys.last_name.tr(),
                        controller: lastNameController,
                        validator: (value) => Validators.name(value, fieldName: LocaleKeys.last_name.tr()),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LocaleKeys.phone_label.tr(),
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        validator: (value) => Validators.phone(value),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LocaleKeys.email.tr(),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) => Validators.email(value),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LocaleKeys.password_label.tr(),
                        isPassword: true,
                        controller: passwordController,
                        validator: (value) => Validators.password(value),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        label: LocaleKeys.confirm_password.tr(),
                        isPassword: true,
                        controller: confirmPasswordController,
                        validator: (value) => Validators.confirmPassword(value, passwordController.text),
                      ),
                      SizedBox(height: 35.h),
                      CustomElevatedButton(
                        text: LocaleKeys.register_button.tr(),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // TODO: register logic
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                      AuthQuestionRow(
                        question: LocaleKeys.already_have_account.tr(),
                        actionText: LocaleKeys.login_button.tr(),
                        onActionTap: () {
                          Navigator.pushNamed(context, RoutesManager.logIn);
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}