import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class CouponSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApplyCoupon;

  const CouponSection({
    super.key,
    required this.controller,
    required this.onApplyCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.doYouHaveCoupon.tr(),
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: LocaleKeys.pleaseEnterCoupon.tr(),
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? ColorsManager.white70
                        : ColorsManager.greyText,
                  ),
                  prefixIcon: Icon(
                    Icons.local_offer_outlined,
                    color: isDarkMode
                        ? ColorsManager.white70
                        : ColorsManager.greyText,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? ColorsManager.white70
                          : ColorsManager.greyBorder,
                      width: 1.5.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: ColorsManager.primaryTeal,
                      width: 2.w,
                    ),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: onApplyCoupon,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isDarkMode ? ColorsManager.white : ColorsManager.black,
                foregroundColor:
                isDarkMode ? ColorsManager.black : ColorsManager.white,
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                LocaleKeys.applyCoupon.tr(),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? ColorsManager.black : ColorsManager.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}