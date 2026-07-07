// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_manager.dart';
import 'app_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsManager.primaryTeal,
    scaffoldBackgroundColor: ColorsManager.white,
    fontFamily: GoogleFonts.alexandria().fontFamily,

    textTheme: TextTheme(
      displayLarge: LightAppStyle.title,
      displayMedium: LightAppStyle.subtitle,
      displaySmall: LightAppStyle.labelStyle,
      bodyLarge: LightAppStyle.bodyText,
      bodyMedium: LightAppStyle.bodyText.copyWith(fontSize: 12.sp),
      labelLarge: LightAppStyle.labelStyle,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.white,
      foregroundColor: ColorsManager.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: LightAppStyle.title.copyWith(
        fontSize: 20.sp,
        color: ColorsManager.black,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.white,
      selectedItemColor: ColorsManager.primaryTeal,
      unselectedItemColor: ColorsManager.greyText,
      selectedLabelStyle: LightAppStyle.subtitle.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: LightAppStyle.subtitle.copyWith(
        fontSize: 11.sp,
      ),
      type: BottomNavigationBarType.fixed,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.white,
      labelStyle: LightAppStyle.labelStyle.copyWith(
        color: ColorsManager.greyText,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.greyBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.greyBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.primaryTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.error),
      ),
    ),

    colorScheme: const ColorScheme.light(
      primary: ColorsManager.primaryTeal,
      secondary: ColorsManager.primaryTeal,
      error: ColorsManager.error,
      surface: ColorsManager.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsManager.primaryTeal,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    fontFamily: GoogleFonts.alexandria().fontFamily,

    textTheme: TextTheme(
      displayLarge: DarkAppStyle.title,
      displayMedium: DarkAppStyle.subtitle,
      displaySmall: DarkAppStyle.labelStyle,
      bodyLarge: DarkAppStyle.bodyText,
      bodyMedium: DarkAppStyle.bodyText.copyWith(fontSize: 12.sp),
      labelLarge: DarkAppStyle.labelStyle,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.darkSurface,
      foregroundColor: ColorsManager.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: DarkAppStyle.title.copyWith(
        fontSize: 20.sp,
        color: ColorsManager.white,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.darkSurface,
      selectedItemColor: ColorsManager.primaryTeal,
      unselectedItemColor: ColorsManager.white70,
      selectedLabelStyle: DarkAppStyle.subtitle.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: DarkAppStyle.subtitle.copyWith(
        fontSize: 11.sp,
      ),
      type: BottomNavigationBarType.fixed,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkSurface,
      labelStyle: DarkAppStyle.labelStyle.copyWith(
        color: ColorsManager.white70,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.white70),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.white70),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.primaryTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsManager.error),
      ),
    ),

    colorScheme: const ColorScheme.dark(
      primary: ColorsManager.primaryTeal,
      secondary: ColorsManager.primaryTeal,
      error: ColorsManager.error,
      surface: ColorsManager.darkSurface,
    ),
  );
}