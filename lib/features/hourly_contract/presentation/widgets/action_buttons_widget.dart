import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';
import '../../../dynamic_steps/presentation/cubit/dynamic_steps_cubit.dart';
import '../../domain/entities/selected_package_entity.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';

class ActionButtonsWidget extends StatelessWidget {
  final List<String> selectedDays;
  final SelectedPackageEntity? selectedPackage;
  final String? stepId;
  final String? serviceId;
  final Map<String, dynamic>? contractData;
  final DynamicStepEntity? stepDetailsEntity;
  final String? dynamicHourlyPricingId;
  final bool isDarkMode;
  final VoidCallback onShowVisits;
  final Function(BuildContext, HourlyContractState) onCompleteContract;
  final HourlyContractState state;

  const ActionButtonsWidget({
    super.key,
    required this.selectedDays,
    required this.selectedPackage,
    required this.stepId,
    required this.serviceId,
    required this.contractData,
    required this.stepDetailsEntity,
    required this.dynamicHourlyPricingId,
    required this.isDarkMode,
    required this.onShowVisits,
    required this.onCompleteContract,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxDays = selectedPackage?.weeklyVisits ?? 1;
    final allDaysSelected = selectedDays.length == maxDays && maxDays > 0;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onShowVisits,
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
            onPressed: allDaysSelected
                ? () => _handleCompleteContract(context)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: allDaysSelected
                  ? (isDarkMode ? ColorsManager.white : ColorsManager.black)
                  : (isDarkMode
                  ? ColorsManager.white.withOpacity(0.5)
                  : ColorsManager.black.withOpacity(0.5)),
              foregroundColor: allDaysSelected
                  ? (isDarkMode ? ColorsManager.black : ColorsManager.white)
                  : (isDarkMode ? ColorsManager.black : ColorsManager.white70),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              LocaleKeys.completeContract.tr(),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: allDaysSelected
                    ? (isDarkMode ? ColorsManager.black : ColorsManager.white)
                    : (isDarkMode
                    ? ColorsManager.black.withOpacity(0.5)
                    : ColorsManager.white70),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCompleteContract(BuildContext context) {
    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.please_select_days_first.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final maxDays = selectedPackage?.weeklyVisits ?? 1;
    if (selectedDays.length != maxDays) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.exact_days_required.tr(
              namedArgs: {'count': maxDays.toString()},
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (stepDetailsEntity != null) {
      onCompleteContract(context, state);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جاري تحميل تفاصيل الخطوة...'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}