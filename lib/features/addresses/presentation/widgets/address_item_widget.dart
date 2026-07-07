import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class AddressItemWidget extends StatelessWidget {
  final String address;
  final bool isSelected;
  final bool isAvailable;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const AddressItemWidget({
    super.key,
    required this.address,
    required this.isSelected,
    required this.isAvailable,
    required this.isDarkMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: isAvailable ? onTap : null,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: !isAvailable
              ? (isDarkMode
                    ? Colors.grey.withOpacity(0.05)
                    : const Color(0xFFF9F9F9))
              : (isDarkMode ? ColorsManager.darkCard : ColorsManager.white),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: !isAvailable
                ? Colors.transparent
                : (isSelected
                      ? (isDarkMode ? ColorsManager.white : ColorsManager.black)
                      : (isDarkMode
                            ? ColorsManager.white70
                            : ColorsManager.greyBorder)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: textTheme.displayMedium?.copyWith(
                      fontSize: 14.sp,
                      height: 1.4,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isDarkMode
                          ? ColorsManager.white
                          : ColorsManager.black,
                    ),
                  ),
                  if (!isAvailable) ...[
                    SizedBox(height: 10.h),
                    Text(
                      LocaleKeys.service_not_available_at_address.tr(),
                      style: LightAppStyle.subtitle.copyWith(
                        fontSize: 12.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (isAvailable) ...[
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected
                    ? (isDarkMode ? ColorsManager.white : ColorsManager.black)
                    : Colors.grey.shade400,
                size: 24.sp,
              ),
              SizedBox(width: 16.w),
            ],
          ],
        ),
      ),
    );
  }
}
