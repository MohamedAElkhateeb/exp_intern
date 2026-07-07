import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../domain/entities/selected_package_entity.dart';
import '../../domain/entities/package_property_configEntity.dart';



class PackageItemWidget extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final bool isDarkMode;
  final VoidCallback onExpand;
  final VoidCallback? onSelect;
  final SelectedPackageEntity package;
  final Map<String, PackagePropertyConfigEntity> properties;

  const PackageItemWidget({
    super.key,
    required this.index,
    required this.isExpanded,
    required this.isDarkMode,
    required this.onExpand,
    this.onSelect,
    required this.package,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: isExpanded
            ? (isDarkMode ? ColorsManager.darkSurface : const Color(0xFFE5E5E5))
            : (isDarkMode ? ColorsManager.darkCard : const Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade400, width: 1.w),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onExpand,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.displayName,
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              '${package.totalPriceWithVatBeforePromotion}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${package.finalPrice} ريال',
                              style: textTheme.labelLarge?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                    size: 24.sp,
                    color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            InkWell(
              onTap: onSelect,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? ColorsManager.darkCard : ColorsManager.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                ),
                child: Column(
                  children: [
                    ...properties.entries.map((entry) {
                      final key = entry.key;
                      final config = entry.value;

                      final String value = _getPropertyValue(key);

                      if (value.isEmpty) return const SizedBox.shrink();

                      return _buildDetailRow(
                        context,
                        '${_getLabelKey(key)} :',
                        value,
                        valueColor: config.color,
                        isBold: config.isBold,
                        isStrike: config.isStrike,
                      );
                    }),

                    SizedBox(height: 8.h),
                    if (package.promotionCode != null &&
                        package.promotionOfferList != null &&
                        package.promotionOfferList!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '💡 ${LocaleKeys.offer_details.tr()}: ${package.promotionOfferList!.first.promotionDescription}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPropertyValue(String key) {
    switch (key) {
      case 'resourceGroupName':
        return package.resourceGroupName;
      case 'contractDurationName':
        return package.contractDurationName;
      case 'weeklyVisitName':
        return package.weeklyVisitName;
      case 'employeeNumberName':
        return package.employeeNumberName;
      case 'visitShiftName':
        return package.visitShiftName;
      case 'finalPrice':
        return '${package.finalPrice} ريال';
      case 'packagePrice':
        return '${package.packagePrice}';
      case 'visitHours':
        return '${package.visitHours}';
      case 'totalVisits':
        return '${package.totalVisits}';
      case 'promotionTotalDiscountAmount':
        return '${package.promotionTotalDiscountAmount}';
      case 'priceAfterTotalDiscount':
        return '${package.priceAfterTotalDiscount}';
      case 'vatRate':
        return '%${package.vatRate}';
      case 'vatAmount':
        return '${package.vatAmount}';
      default:
        return '';
    }
  }

  String _getLabelKey(String key) {
    switch (key) {
      case 'resourceGroupName':
        return LocaleKeys.resourceGroupName.tr();
      case 'contractDurationName':
        return LocaleKeys.contractDurationName.tr();
      case 'weeklyVisitName':
        return LocaleKeys.weeklyVisitName.tr();
      case 'employeeNumberName':
        return LocaleKeys.employeeNumberName.tr();
      case 'visitShiftName':
        return LocaleKeys.visitShiftName.tr();
      case 'finalPrice':
        return LocaleKeys.finalPrice.tr();
      case 'packagePrice':
        return LocaleKeys.packagePrice.tr();
      case 'visitHours':
        return LocaleKeys.visitHours.tr();
      case 'totalVisits':
        return LocaleKeys.totalVisits.tr();
      case 'promotionTotalDiscountAmount':
        return LocaleKeys.promotionTotalDiscountAmount.tr();
      case 'priceAfterTotalDiscount':
        return LocaleKeys.priceAfterTotalDiscount.tr();
      case 'vatRate':
        return LocaleKeys.vatRate.tr();
      case 'vatAmount':
        return LocaleKeys.vatAmount.tr();
      default:
        return key;
    }
  }

  Widget _buildDetailRow(
      BuildContext context,
      String label,
      String value, {
        Color? valueColor,
        bool isBold = false,
        bool isStrike = false,
      }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? (isDarkMode ? ColorsManager.white : ColorsManager.black),
              decoration: isStrike ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}