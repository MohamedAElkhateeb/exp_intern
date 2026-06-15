// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors_manager.dart';

class AppTheme {
  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsManager.primaryTeal,
    scaffoldBackgroundColor: ColorsManager.white,
    fontFamily: GoogleFonts.alexandria().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.white,
      foregroundColor: ColorsManager.black,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.white,
      selectedItemColor: ColorsManager.primaryTeal,
      unselectedItemColor: ColorsManager.greyText,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.white,
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
    ),
    textTheme: GoogleFonts.alexandriaTextTheme().copyWith(
      displayLarge: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: ColorsManager.black),
      displayMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: ColorsManager.black),
      displaySmall: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorsManager.black),
      bodyLarge: TextStyle(fontSize: 14.sp, color: ColorsManager.black),
      bodyMedium: TextStyle(fontSize: 12.sp, color: ColorsManager.greyText),
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: ColorsManager.black),
    ),
    colorScheme: const ColorScheme.light(
      primary: ColorsManager.primaryTeal,
      secondary: ColorsManager.primaryTeal,
      error: ColorsManager.error,
      surface: ColorsManager.white,
    ),
  );

  /// 🌚 Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsManager.primaryTeal,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    fontFamily: GoogleFonts.alexandria().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.darkSurface,
      foregroundColor: ColorsManager.white,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.darkSurface,
      selectedItemColor: ColorsManager.primaryTeal,
      unselectedItemColor: ColorsManager.white70,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkSurface,
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
    ),
    textTheme: GoogleFonts.alexandriaTextTheme().copyWith(
      displayLarge: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: ColorsManager.white),
      displayMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: ColorsManager.white),
      displaySmall: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorsManager.white),
      bodyLarge: TextStyle(fontSize: 14.sp, color: ColorsManager.white80),
      bodyMedium: TextStyle(fontSize: 12.sp, color: ColorsManager.white70),
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: ColorsManager.white),
    ),
    colorScheme: const ColorScheme.dark(
      primary: ColorsManager.primaryTeal,
      secondary: ColorsManager.primaryTeal,
      error: ColorsManager.error,
      surface: ColorsManager.darkSurface,
    ),
  );
}