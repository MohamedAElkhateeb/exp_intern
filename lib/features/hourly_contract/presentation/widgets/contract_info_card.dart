import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:exp_intern/core/utils/colors_manager.dart';

import '../../../../core/utils/locale_keys.g.dart';

class ContractInfoCard extends StatelessWidget {
  final bool isDarkMode;
  final String contractNumber;
  final String contractValue;

  const ContractInfoCard({
    super.key,
    required this.isDarkMode,
    required this.contractNumber,
    required this.contractValue,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ تم إزالة الحاوية والحدود والخلفية، وجعل التصميم نصوص متمركزة
    return Column(
      children: [
        // ✅ رقم العقد
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ توسيط النص
          children: [
            Text(
              '${LocaleKeys.contract_number.tr()} ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.grey400 : ColorsManager.grey600,
              ),
            ),
            Text(
              contractNumber,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${LocaleKeys.contract_value.tr()} ',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.grey400 : ColorsManager.black,
              ),
            ),
            Text(
              '$contractValue ${LocaleKeys.riyal.tr()}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? ColorsManager.white : ColorsManager.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}