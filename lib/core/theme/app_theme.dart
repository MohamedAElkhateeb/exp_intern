// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// 🌞 Light Theme ديناميكي يتغير حسب اللغة
  static ThemeData light= ThemeData(
      textTheme:
          GoogleFonts.alexandriaTextTheme()
    );


  /// 🌚 Dark Theme
  static ThemeData dark = ThemeData();
}