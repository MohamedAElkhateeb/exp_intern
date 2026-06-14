// features/auth/presentation/screens/forget_screen.dart
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
import '../widgets/custom_logo.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80.h),
                CustomLogo(fontSize: 50.sp),
                SizedBox(height: 60.h),
                Text(LocaleKeys.forgot_password_title.tr(), style: LightAppStyle.title),
                SizedBox(height: 8.h),
                Text(
                  LocaleKeys.forgot_password_subtitle.tr(),
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
                SizedBox(height: 40.h),
                CustomElevatedButton(
                  text: LocaleKeys.send_reset_link.tr(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        RoutesManager.newPassword,
                        arguments: phoneController.text,
                      );
                    }
                  },
                ),
                SizedBox(height: 24.h),
                AuthQuestionRow(
                  question: LocaleKeys.remember_password_question.tr(),
                  actionText: LocaleKeys.login_button.tr(),
                  onActionTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}