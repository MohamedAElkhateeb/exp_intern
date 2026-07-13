import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:exp_intern/core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class WalletBalanceCard extends StatelessWidget {
  final bool isDarkMode;
  final String walletBalance;
  final String usableBalance;

  const WalletBalanceCard({
    super.key,
    required this.isDarkMode,
    required this.walletBalance,
    required this.usableBalance,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDarkMode ? ColorsManager.darkBorder : ColorsManager.lightBorder;
    final textColor = isDarkMode ? ColorsManager.white : ColorsManager.black;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFF0F0F0), // ✅ خلفية رمادية فاتحة
        borderRadius: BorderRadius.circular(8.r), // ✅ حواف مستطيلة قليلاً
        border: Border.all(
          color: borderColor.withOpacity(0.5), // ✅ حدود خفيفة
          width: 1,
        ),
      ),
      child: Row(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${LocaleKeys.your_wallet_balance_is.tr()}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Text(
                '$usableBalance ${LocaleKeys.riyal.tr()} ${LocaleKeys.can_use.tr()}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const Spacer(),

          Container(
            width: 70.w,
            height: 35.h,
            decoration: BoxDecoration(
              color: ColorsManager.grey400, // ✅ لون رمادي متوسط
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                LocaleKeys.exchange.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 50.w,
            height: 35.h,
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: ColorsManager.grey400),
            ),
            child: Center(
              child: Text(
                walletBalance, // "0"
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}