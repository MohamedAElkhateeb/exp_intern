import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:exp_intern/core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class PaymentAlertCard extends StatelessWidget {
  final bool isDarkMode;
  final String amountToPay;
  final String text;


  const PaymentAlertCard({
    super.key,
    required this.isDarkMode,
    required this.amountToPay,
    required this.text,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.primaryTeal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}