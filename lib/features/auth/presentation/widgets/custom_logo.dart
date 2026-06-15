import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/utils/colors_manager.dart';

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
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Column(
      children: [
        Text(
          'Logo',
          style: LightAppStyle.logoStyle.copyWith(
            fontSize: fontSize ?? 40.sp,
            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
          ),
        ),
      ],
    );
  }
}