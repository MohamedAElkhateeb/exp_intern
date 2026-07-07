import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';

class HorizontalFilterWidget extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final bool isDarkMode;
  final double? fixedWidth;

  const HorizontalFilterWidget({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    required this.isDarkMode,
    this.fixedWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item == selectedValue;

          return InkWell(
            onTap: () => onSelected(item),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: fixedWidth,
              padding: fixedWidth != null
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: 18.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDarkMode ? ColorsManager.white : ColorsManager.black)
                    : (isDarkMode ? ColorsManager.darkSurface : const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                item,
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? (isDarkMode ? ColorsManager.black : ColorsManager.white)
                      : (isDarkMode ? ColorsManager.white70 : ColorsManager.black),
                ),              ),
            ),
          );
        },
      ),
    );
  }
}