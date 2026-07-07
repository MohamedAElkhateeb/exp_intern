import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';

class DeliveryNotesWidget extends StatelessWidget {
  final bool isDarkMode;

  const DeliveryNotesWidget({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsManager.darkCard : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode ? ColorsManager.white70 : Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.deliveryTimes.tr(),
            style: textTheme.labelLarge?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
          SizedBox(height: 6.h),

          BlocBuilder<HourlyContractCubit, HourlyContractState>(
            buildWhen: (previous, current) => previous.deliveryNotesText != current.deliveryNotesText,
            builder: (context, state) {
              final displayText = state.deliveryNotesText.isNotEmpty
                  ? state.deliveryNotesText
                  : LocaleKeys.loading_delivery_times.tr();

              return Text(
                displayText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}