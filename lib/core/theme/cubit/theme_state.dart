abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {}

class ThemeChanged extends ThemeState {
  final bool isDarkMode;

  const ThemeChanged({required this.isDarkMode});
}