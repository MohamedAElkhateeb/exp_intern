import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../cubit/hourly_contract_state.dart';
import 'day_item_widget.dart';

class PreferredDaysSection extends StatelessWidget {
  final HourlyContractState state;
  final List<String> selectedDays;
  final int maxDays;
  final bool isDarkMode;
  final Function(String, bool) onDayTap;
  final bool showMaxDaysMessage;

  const PreferredDaysSection({
    super.key,
    required this.state,
    required this.selectedDays,
    required this.maxDays,
    required this.isDarkMode,
    required this.onDayTap,
    required this.showMaxDaysMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: LocaleKeys.preferredDays.tr(),
            labelStyle: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? ColorsManager.white70 : ColorsManager.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDarkMode
                    ? ColorsManager.white70
                    : ColorsManager.greyBorder,
                width: 1.5.w,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: _buildContent(theme),
          ),
        ),
        SizedBox(height: 8.h),
        if (showMaxDaysMessage)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              LocaleKeys.max_days_selected_message.tr(
                namedArgs: {'maxDays': maxDays.toString()},
              ),
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (state.availableDays.status == RequestStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.availableDays.data.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            LocaleKeys.no_days_available.tr(),
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return GridView.builder(
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
        final isSelected = selectedDays.contains(dayEntity.date);

        return DayItemWidget(
          dayEntity: dayEntity,
          isSelected: isSelected,
          isDarkMode: isDarkMode,
          onTap: () => onDayTap(dayEntity.date, isSelected),
        );
      },
    );
  }
}