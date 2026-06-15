// features/auth/presentation/screens/new_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_logo.dart';
import '../widgets/resend_timer_row.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    verificationCodeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResendCode() {
    CustomDialogs.showSuccessSnackBar(
      context,
      LocaleKeys.code_resent_successfully.tr(),
    );
  }

  void _handleResetPassword() {
    if (formKey.currentState!.validate()) {
      CustomDialogs.showPasswordResetSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context)?.settings.arguments as String? ?? "012345678";
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : ColorsManager.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                CustomLogo(fontSize: 50.sp),
                SizedBox(height: 40.h),
                Text(
                  LocaleKeys.new_password_title.tr(),
                  style: LightAppStyle.title.copyWith(
                    color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  '${LocaleKeys.verification_code_sent.tr()} $phoneNumber',
                  style: LightAppStyle.subtitle.copyWith(
                    color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  label: LocaleKeys.verification_code.tr(),
                  keyboardType: TextInputType.number,
                  controller: verificationCodeController,
                  validator: (value) => Validators.required(value),
                ),
                SizedBox(height: 12.h),
                ResendTimerRow(onResend: _handleResendCode, initialSeconds: 58),
                SizedBox(height: 24.h),
                CustomTextField(
                  label: LocaleKeys.new_password_label.tr(),
                  isPassword: true,
                  controller: newPasswordController,
                  validator: (value) => Validators.password(value),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  label: LocaleKeys.confirm_new_password_label.tr(),
                  isPassword: true,
                  controller: confirmPasswordController,
                  validator: (value) => Validators.confirmPassword(value, newPasswordController.text),
                ),
                SizedBox(height: 32.h),
                CustomElevatedButton(
                  text: LocaleKeys.reset_and_login.tr(),
                  onPressed: _handleResetPassword,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}