part of 'bloc.dart';

sealed class LocalOptionsEvent {}

class ThemeModeChanged extends LocalOptionsEvent {
  ThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;
}

class ColorSchemeChanged extends LocalOptionsEvent {
  ColorSchemeChanged(
      {required this.useSystemColorScheme, required this.seedColorScheme});

  final bool useSystemColorScheme;
  final Color seedColorScheme;
}
