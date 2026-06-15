// lib/core/widgets/resend_timer_row.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';

class ResendTimerRow extends StatefulWidget {
  final VoidCallback? onResend;
  final int initialSeconds;
  final String? phoneNumber;

  const ResendTimerRow({
    super.key,
    this.onResend,
    this.initialSeconds = 58,
    this.phoneNumber,
  });

  @override
  State<ResendTimerRow> createState() => _ResendTimerRowState();
}

class _ResendTimerRowState extends State<ResendTimerRow> {
  late int secondsRemaining;
  bool canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    secondsRemaining = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      secondsRemaining = widget.initialSeconds;
      canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 1) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _handleResend() {
    if (canResend) {
      _startTimer();
      widget.onResend?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.did_not_receive_code.tr(),
          style: LightAppStyle.bodyText.copyWith(
            fontSize: 12.sp,
            color: isDarkMode ? ColorsManager.white70 : ColorsManager.greyText,
          ),
        ),
        SizedBox(width: 4.w),
        canResend
            ? GestureDetector(
          onTap: _handleResend,
          child: Text(
            LocaleKeys.resend_code.tr(),
            style: LightAppStyle.linkText.copyWith(fontSize: 12.sp),
          ),
        )
            : Row(
          children: [
            Text(
              '${LocaleKeys.resend_after.tr()} 00:${secondsRemaining.toString().padLeft(2, '0')}',
              style: LightAppStyle.bodyText.copyWith(
                fontSize: 12.sp,
                color: ColorsManager.primaryTeal,
              ),
            ),
            SizedBox(width: 5.w),
            Icon(
              Icons.watch_later_outlined,
              size: 16.sp,
              color: ColorsManager.primaryTeal,
            ),
          ],
        ),
      ],
    );
  }
}