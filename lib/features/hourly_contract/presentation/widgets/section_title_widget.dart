import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: textTheme.displayMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
        ),
      ),
    );
  }
}