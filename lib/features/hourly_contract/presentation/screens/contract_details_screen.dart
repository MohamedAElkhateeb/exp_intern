import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/features/dynamic_steps/domain/entity/dynamic_step_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';

class ContractDetailsScreen extends StatefulWidget {
  const ContractDetailsScreen({super.key});

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  final TextEditingController _couponController = TextEditingController();

  String? selectedDayKey;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LocaleKeys.contractDetails.tr(),
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              size: 28.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCouponSection(theme, isDarkMode),
            SizedBox(height: 20.h),

            BlocBuilder<HourlyContractCubit, HourlyContractState>(
              builder: (context, state) {
                return _buildPreferredDaysSection(theme, isDarkMode, state);
              },
            ),
            SizedBox(height: 20.h),

            _buildPackageCard(theme, isDarkMode),
            SizedBox(height: 24.h),

            _buildTermsAndConditions(theme),
            SizedBox(height: 24.h),

            _buildActionButtons(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(ThemeData theme, bool isDarkMode) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: LocaleKeys.doYouHaveCoupon.tr(),
        labelStyle: theme.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
            width: 1.5.w,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.pleaseEnterCoupon.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? ColorsManager.white : ColorsManager.black,
                foregroundColor: isDarkMode ? ColorsManager.black : ColorsManager.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
      ),
    );
  }

  Widget _buildPreferredDaysSection(ThemeData theme, bool isDarkMode, HourlyContractState state) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: LocaleKeys.preferredDays.tr(),
        labelStyle: theme.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
            width: 1.5.w,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: state.availableDays.status == RequestStatus.loading
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        )
            : state.availableDays.data.isEmpty
            ? Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              LocaleKeys.no_days_available.tr(),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        )
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.availableDays.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (context, index) {
            final dayEntity = state.availableDays.data[index];
            final isSelected = dayEntity.date == selectedDayKey;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDayKey = dayEntity.date;
                });
              },
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
                      dayEntity.dayName ,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? (isDarkMode ? ColorsManager.black : ColorsManager.white)
                            : (isDarkMode ? ColorsManager.white70 : ColorsManager.black),
                      ),
                    ),
                    Text(
                      dayEntity.date ,
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
          },
        ),
      ),
    );
  }

  Widget _buildPackageCard(ThemeData theme, bool isDarkMode) {
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
              LocaleKeys.visitPrice.tr(args: ['240.00']),
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
                LocaleKeys.currencySar.tr(args: ['9,800.00']),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '12,800.00',
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

  Widget _buildTermsAndConditions(ThemeData theme) {
    return Column(
      children: [
        Text(
          LocaleKeys.byCompletingSteps.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () {},
          child: Text(
            LocaleKeys.companyTerms.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryTeal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                width: 1.5.w,
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              LocaleKeys.showVisits.tr(),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? ColorsManager.white : ColorsManager.black,
              foregroundColor: isDarkMode ? ColorsManager.black : ColorsManager.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              LocaleKeys.completeContract.tr(),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.black : ColorsManager.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}