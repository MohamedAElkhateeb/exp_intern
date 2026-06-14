// features/auth/presentation/screens/login_screen.dart
import 'package:exp_intern/features/auth/presentation/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/auth_question_row.dart';
import '../widgets/language_switch_row.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
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
                Text(LocaleKeys.login_title.tr(), style: LightAppStyle.title),
                SizedBox(height: 8.h),
                Text(
                  LocaleKeys.login_subtitle.tr(),
                  style: LightAppStyle.subtitle,
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
                    Navigator.pushNamed(context, RoutesManager.forgetPassword);
                  },
                ),
                SizedBox(height: 24.h),
                CustomElevatedButton(
                  text: LocaleKeys.login_button.tr(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // TODO: login logic
                    }
                  },
                ),
                SizedBox(height: 24.h),
                AuthQuestionRow(
                  question: LocaleKeys.no_account_question.tr(),
                  actionText: LocaleKeys.create_account.tr(),
                  onActionTap: () {
                    Navigator.pushNamed(context, RoutesManager.register);
                  },
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {},
                  child: Text(LocaleKeys.skip_now.tr(), style: LightAppStyle.bodyText.copyWith(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 40.h),
                const LanguageSwitchRow(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}