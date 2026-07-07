// app_styles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_manager.dart';

class LightAppStyle {
  static TextStyle logoStyle = TextStyle(
    color: ColorsManager.black,
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title = TextStyle(
    color: ColorsManager.black,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitle = TextStyle(
    color: ColorsManager.greyText,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelStyle = TextStyle(
    color: ColorsManager.black,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyText = TextStyle(
    color: ColorsManager.black,
    fontSize: 14.sp,
  );

  static TextStyle linkText = TextStyle(
    color: ColorsManager.primaryTeal,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );
}

class DarkAppStyle {
  static TextStyle logoStyle = TextStyle(
    color: ColorsManager.white,
    fontSize: 36.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title = TextStyle(
    color: ColorsManager.white,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitle = TextStyle(
    color: ColorsManager.white70,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelStyle = TextStyle(
    color: ColorsManager.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyText = TextStyle(
    color: ColorsManager.white80,
    fontSize: 14.sp,
  );

  static TextStyle linkText = TextStyle(
    color: ColorsManager.primaryTeal,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );
}