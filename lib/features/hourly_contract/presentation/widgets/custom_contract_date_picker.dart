import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/features/hourly_contract/domain/entities/time_slot_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// قم بتعديل مسار الاستيراد بناءً على مكان ملف الـ AppCalendarPicker في مشروعك
import '../../../../core/widgets/app_calendar_picker.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class CustomContractDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedTimeSlotId;
  final TimeSlotEntity? currentTimeSlot;
  final bool isDarkMode;
  final Function(DateTime) onDateSelected;

  const CustomContractDatePicker({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlotId,
    required this.currentTimeSlot,
    required this.isDarkMode,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (selectedTimeSlotId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.selectVisitTime.tr())),
          );
          return;
        }

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
              backgroundColor: isDarkMode ? ColorsManager.darkBackground : Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.firstVisitDate.tr(),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.h),
                    AppCalendarPicker(
                      selectedDate: selectedDate,
                      minDateString: currentTimeSlot?.minDate,
                      maxDateString: currentTimeSlot?.maxDate,
                      isDarkMode: isDarkMode,
                      onDateSelected: (date) {
                        onDateSelected(date);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: LocaleKeys.firstVisitDate.tr(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          labelStyle: TextStyle(
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyBorder,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDarkMode ? ColorsManager.white : ColorsManager.greyBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isDarkMode ? ColorsManager.white : ColorsManager.black,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                  : LocaleKeys.select.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                color: isDarkMode
                    ? Colors.white
                    : (selectedDate != null ? Colors.black : Colors.grey),
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: isDarkMode ? ColorsManager.white : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}