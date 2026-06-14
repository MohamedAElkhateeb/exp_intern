import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';

class CustomLogo extends StatelessWidget {
  final double? height;
  final double? fontSize;

  const CustomLogo({
    super.key,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Logo',
          style: LightAppStyle.logoStyle.copyWith(
            fontSize: fontSize ?? 40.sp,
          ),
        ),
      ],
    );
  }
}