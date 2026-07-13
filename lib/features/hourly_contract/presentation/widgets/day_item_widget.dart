import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';

class DayItemWidget extends StatelessWidget {
  final dynamic dayEntity;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const DayItemWidget({
    super.key,
    required this.dayEntity,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? ColorsManager.white : ColorsManager.black)
              : (isDarkMode ? ColorsManager.darkSurface : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayEntity.dayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? (isDarkMode ? ColorsManager.black : ColorsManager.white)
                    : (isDarkMode ? ColorsManager.white70 : ColorsManager.black),
              ),
            ),
            Text(
              dayEntity.date,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? (isDarkMode ? ColorsManager.black : ColorsManager.white)
                    : (isDarkMode ? ColorsManager.white70 : ColorsManager.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}