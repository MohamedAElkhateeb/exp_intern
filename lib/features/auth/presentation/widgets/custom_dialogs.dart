// lib/core/utils/custom_dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/routes_manager.dart';
import '../../../../core/widgets/custom_elevated_button.dart';


class CustomDialogs {
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            title,
            style: LightAppStyle.title.copyWith(fontSize: 18.sp),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: LightAppStyle.subtitle,
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                text: buttonText ?? LocaleKeys.ok.tr(),
                onPressed: onButtonPressed ?? () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showPasswordResetSuccessDialog(BuildContext context) {
    return showSuccessDialog(
      context: context,
      title: LocaleKeys.password_reset_success.tr(),
      message: LocaleKeys.password_changed_successfully.tr(),
      buttonText: LocaleKeys.login_button.tr(),
      onButtonPressed: () {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesManager.logIn,
              (route) => false,
        );
      },
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}