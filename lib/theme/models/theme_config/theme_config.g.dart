// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ThemeConfig',
      json,
      ($checkedConvert) {
        final val = ThemeConfig(
          colorSchemeMode: $checkedConvert(
              'color_scheme_mode', (v) => $enumDecode(_$ThemeModeEnumMap, v)),
          seedColor: $checkedConvert(
              'seed_color', (v) => ThemeConfig._colorFromInt(v as int)),
          wallBasedColorScheme:
              $checkedConvert('wall_based_color_scheme', (v) => v as bool),
          bodyTextScaleFactor: $checkedConvert(
              'body_text_scale_factor', (v) => (v as num).toDouble()),
          labelTextScaleFactor: $checkedConvert(
              'label_text_scale_factor', (v) => (v as num).toDouble()),
          titleTextScaleFactor: $checkedConvert(
              'title_text_scale_factor', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'colorSchemeMode': 'color_scheme_mode',
        'seedColor': 'seed_color',
        'wallBasedColorScheme': 'wall_based_color_scheme',
        'bodyTextScaleFactor': 'body_text_scale_factor',
        'labelTextScaleFactor': 'label_text_scale_factor',
        'titleTextScaleFactor': 'title_text_scale_factor'
      },
    );

Map<String, dynamic> _$ThemeConfigToJson(ThemeConfig instance) =>
    <String, dynamic>{
      'color_scheme_mode': _$ThemeModeEnumMap[instance.colorSchemeMode]!,
      'wall_based_color_scheme': instance.wallBasedColorScheme,
      'seed_color': ThemeConfig._colorToInt(instance.seedColor),
      'body_text_scale_factor': instance.bodyTextScaleFactor,
      'label_text_scale_factor': instance.labelTextScaleFactor,
      'title_text_scale_factor': instance.titleTextScaleFactor,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
