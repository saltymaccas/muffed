part of 'bloc.dart';

@freezed
class LocalOptionsState with _$LocalOptionsState {
  const factory LocalOptionsState({
    required ThemeMode themeMode,
    @ColorConverter() required Color seedColor,
    required bool useSystemSeedColor,
  }) = _LocalOptionsState;

  factory LocalOptionsState.fromJson(Map<String, Object?> json) =>
      _$LocalOptionsStateFromJson(json);
}

extension ThemeModeHumaneString on ThemeMode {
  String toHumaneString() {
    switch (this) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'copy system';
    }
  }
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}
