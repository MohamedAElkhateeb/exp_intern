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

  DateTime _parseDate(String? dateString) {
    if (dateString == null) return DateTime.now();

    final cleanDate = dateString.trim().split(' ')[0];

    try {
      return DateFormat("yyyy-MM-dd").parse(cleanDate);
    } catch (_) {}

    try {
      return DateFormat("M/d/yyyy").parse(cleanDate);
    } catch (_) {}

    try {
      return DateFormat("dd/MM/yyyy").parse(cleanDate);
    } catch (_) {}

    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstAvailableDate = _parseDate(minDateString);
    DateTime lastAvailableDate = _parseDate(maxDateString);

    // ✅ تأكد أن firstDate <= lastDate
    if (firstAvailableDate.isAfter(lastAvailableDate)) {
      firstAvailableDate = lastAvailableDate;
    }

    // ✅ تحديد initialDate
    DateTime initialDate;
    if (selectedDate != null) {
      initialDate = selectedDate!;
    } else {
      initialDate = firstAvailableDate;
    }

    // ✅ تأكد أن initialDate >= firstDate
    if (initialDate.isBefore(firstAvailableDate)) {
      initialDate = firstAvailableDate;
    }

    // ✅ تأكد أن initialDate <= lastDate
    if (initialDate.isAfter(lastAvailableDate)) {
      initialDate = lastAvailableDate;
    }

    debugPrint('📅 firstAvailableDate: $firstAvailableDate');
    debugPrint('📅 lastAvailableDate: $lastAvailableDate');
    debugPrint('📅 initialDate: $initialDate');

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
          initialDate: initialDate,
          firstDate: firstAvailableDate,
          lastDate: lastAvailableDate,
          onDateChanged: onDateSelected,
        ),
      ),
    );
  }
}