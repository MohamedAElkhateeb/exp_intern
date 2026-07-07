import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? iconWidget;

  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    required,

    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    return InkWell(
      onTap: onTap, // 👈 تفعيل الضغطة هنا
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDarkMode ? ColorsManager.darkCard : ColorsManager.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? ColorsManager.white70
                : ColorsManager.greyBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsManager.white70.withOpacity(0.2)
                    : ColorsManager.greyBorder.withOpacity(0.4),
              ),
              child: iconWidget,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isDarkMode
                          ? ColorsManager.white
                          : ColorsManager.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: textTheme.displayMedium?.copyWith(
                      fontSize: 13.sp,
                      height: 1.3,
                      color: isDarkMode
                          ? ColorsManager.white
                          : ColorsManager.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
