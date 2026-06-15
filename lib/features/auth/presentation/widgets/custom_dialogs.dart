import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
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
    final isDarkMode = context.read<ThemeCubit>().isDarkMode;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: isDarkMode ? ColorsManager.darkSurface : ColorsManager.white,
          title: Text(
            title,
            style: LightAppStyle.title.copyWith(
              fontSize: 18.sp,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: LightAppStyle.subtitle.copyWith(
              color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
            ),
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
        backgroundColor: ColorsManager.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorsManager.primaryTeal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}