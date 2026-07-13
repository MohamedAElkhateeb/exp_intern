import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/colors_manager.dart';
import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';

class ConfirmationDialog extends StatelessWidget {
  final DynamicStepEntity nextStep;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.nextStep,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  nextStep.name ?? LocaleKeys.alert.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  nextStep.description ?? LocaleKeys.please_confirm_next_step.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24.h),
                _buildConfirmButton(context),
              ],
            ),
          ),
          _buildCloseButton(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(140.w, 45.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        LocaleKeys.next.tr(),
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, bool isDarkMode) {
    return Positioned(
      top: -15.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            child: Icon(
              Icons.close,
              size: 18.w,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}