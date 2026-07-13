import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../data/model/hourly_pricing_response_model.dart';
import '../../domain/entities/selected_package_entity.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';

class PackageCardWidget extends StatelessWidget {
  final List<String> selectedDays;
  final SelectedPackageEntity? selectedPackage;
  final bool isDarkMode;

  const PackageCardWidget({
    super.key,
    required this.selectedDays,
    required this.selectedPackage,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxDays = selectedPackage?.weeklyVisits ?? 1;
    final allDaysSelected = selectedDays.length == maxDays && maxDays > 0;

    if (!allDaysSelected) {
      return _buildEmptyState(theme);
    }

    return BlocBuilder<HourlyContractCubit, HourlyContractState>(
      builder: (context, state) {
        if (state.hourlyPricingStatus == RequestStatus.loading) {
          return _buildLoadingState(theme);
        }

        if (state.hourlyPricingStatus == RequestStatus.error) {
          return _buildErrorState(theme, state.hourlyPricingError);
        }

        final pricingData = state.hourlyPricingData;
        if (pricingData == null || pricingData.hourlyPackages.isEmpty) {
          return _buildNoDataState(theme);
        }

        final package = pricingData.hourlyPackages.first;
        return _buildPackageCard(theme, package);
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final maxDays = selectedPackage?.weeklyVisits ?? 1;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today,
            size: 40.sp,
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.select_days_to_view_packages.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.selected_days_count.tr(
              namedArgs: {
                'selected': selectedDays.length.toString(),
                'total': maxDays.toString(),
              },
            ),
            style: TextStyle(
              fontSize: 12.sp,
              color: isDarkMode ? ColorsManager.white : ColorsManager.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
        ),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(ThemeData theme, String? error) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
        ),
      ),
      child: Center(
        child: Text(
          error ?? LocaleKeys.error_loading_pricing.tr(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildNoDataState(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
        ),
      ),
      child: Center(
        child: Text(
          LocaleKeys.no_pricing_data.tr(),
          style: TextStyle(
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(ThemeData theme, HourlyPackageModel package) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkSurface : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  package.packageDisplayName ??
                      LocaleKeys.packageDescription.tr(),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                size: 28.sp,
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              _getVisitPriceText(package),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${LocaleKeys.totalPrice.tr()}: ${package.packagePrice?.toStringAsFixed(2) ?? '0.00'} ${LocaleKeys.sar.tr()}',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              if (package.promotionTotalDiscountAmount != null &&
                  package.promotionTotalDiscountAmount! > 0)
                Text(
                  '${(package.packagePrice ?? 0) + (package.promotionTotalDiscountAmount ?? 0)} ${LocaleKeys.sar.tr()}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: ColorsManager.greyText,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getVisitPriceText(HourlyPackageModel package) {
    if (package.promotionOfferList != null &&
        package.promotionOfferList!.isNotEmpty) {
      final description = package.promotionOfferList!.first.promotionDescription;
      if (description != null && description.isNotEmpty) {
        return description;
      }
    }
    return LocaleKeys.visit_price_text.tr(
      namedArgs: {'price': package.oneVisitPrice?.toStringAsFixed(2) ?? '0.00'},
    );
  }
}