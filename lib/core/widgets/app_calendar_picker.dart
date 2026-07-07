import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_manager.dart';

class AppCalendarPicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String? minDateString;
  final String? maxDateString;
  final bool isDarkMode;
  final Function(DateTime) onDateSelected;

  const AppCalendarPicker({
    super.key,
    required this.selectedDate,
    required this.isDarkMode,
    required this.onDateSelected,
    this.minDateString,
    this.maxDateString,
  });

  @override
  Widget build(BuildContext context) {
    DateTime firstAvailableDate = DateTime.now();
    DateTime lastAvailableDate = DateTime.now().add(const Duration(days: 30));

    if (minDateString != null) {
      try {
        firstAvailableDate = DateFormat("M/d/yyyy").parse(minDateString!.split(' ')[0]);
      } catch (_) {}
    }

    if (maxDateString != null) {
      try {
        lastAvailableDate = DateFormat("M/d/yyyy").parse(maxDateString!.split(' ')[0]);
      } catch (_) {}
    }

    DateTime initialPickerDate = DateTime.now();
    if (initialPickerDate.isBefore(firstAvailableDate)) {
      initialPickerDate = firstAvailableDate;
    } else if (initialPickerDate.isAfter(lastAvailableDate)) {
      initialPickerDate = lastAvailableDate;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: isDarkMode ? ColorsManager.darkBackground : Colors.white,
          onSurface: isDarkMode ? Colors.white : Colors.black,
          onSurfaceVariant: Colors.grey.shade400,
        ),
      ),
      child: SizedBox(
        width: 320.w,
        height: 330.h,
        child: CalendarDatePicker(
          initialDate: selectedDate ?? initialPickerDate,
          firstDate: firstAvailableDate,
          lastDate: lastAvailableDate,
          onDateChanged: onDateSelected,
        ),
      ),
    );
  }
}