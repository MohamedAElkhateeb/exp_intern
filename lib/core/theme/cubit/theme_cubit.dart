// lib/core/themes/cubit/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// جزء الـ states (نفس اللي فوق)
abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {}

class ThemeChanged extends ThemeState {
  final bool isDarkMode;

  const ThemeChanged({required this.isDarkMode});
}

// الـ Cubit
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    _loadSavedTheme();
  }

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadSavedTheme() async {
    // TODO: Load from SharedPreferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(ThemeChanged(isDarkMode: _isDarkMode));
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    // TODO: Save to SharedPreferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isDarkMode', _isDarkMode);
    emit(ThemeChanged(isDarkMode: _isDarkMode));
  }

  void setTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    emit(ThemeChanged(isDarkMode: _isDarkMode));
  }
}