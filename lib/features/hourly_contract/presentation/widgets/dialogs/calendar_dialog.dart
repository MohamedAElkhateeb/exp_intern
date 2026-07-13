import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/colors_manager.dart';
import '../../../../../core/utils/locale_keys.g.dart';
import '../../../../../core/widgets/app_calendar_picker.dart';
import '../../../../dynamic_steps/domain/entity/dynamic_step_entity.dart';
import '../../../domain/entities/time_slot_entity.dart';
import '../../cubit/hourly_contract_cubit.dart';

class CalendarDialog extends StatefulWidget {
  final DateTime? selectedDate;
  final DynamicStepEntity nextStep;
  final TimeSlotEntity? timeSlotEntity;
  final HourlyContractCubit hourlyContractCubit;
  final Function(DateTime) onDateSelected;
  final VoidCallback onConfirm;

  const CalendarDialog({
    super.key,
    required this.selectedDate,
    required this.nextStep,
    required this.timeSlotEntity,
    required this.hourlyContractCubit,
    required this.onDateSelected,
    required this.onConfirm,
  });

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime? _tempSelectedDate;

  @override
  void initState() {
    super.initState();
    _tempSelectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDarkMode ? ColorsManager.darkBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  LocaleKeys.selectFirstVisitDate.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                  ),
                ),
                SizedBox(height: 20.h),
                AppCalendarPicker(
                  selectedDate: _tempSelectedDate,
                  isDarkMode: isDarkMode,
                  minDateString: widget.timeSlotEntity?.minDate,
                  maxDateString: widget.timeSlotEntity?.maxDate,
                  onDateSelected: (date) {
                    setState(() {
                      _tempSelectedDate = date;
                    });
                    widget.onDateSelected(date);
                  },
                ),
                SizedBox(height: 20.h),
                _buildNextButton(context, isDarkMode),
              ],
            ),
          ),
          _buildCloseButton(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, bool isDarkMode) {
    return ElevatedButton(
      onPressed: widget.onConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(140.w, 45.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        LocaleKeys.next.tr(),
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, bool isDarkMode) {
    return Positioned(
      top: -15.h,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            child: Icon(
              Icons.close,
              size: 18.w,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}