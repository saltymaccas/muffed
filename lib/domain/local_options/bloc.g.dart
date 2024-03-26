// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalOptionsStateImpl _$$LocalOptionsStateImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalOptionsStateImpl(
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
      seedColor: const ColorConverter().fromJson(json['seedColor'] as int),
      useSystemSeedColor: json['useSystemSeedColor'] as bool,
    );

Map<String, dynamic> _$$LocalOptionsStateImplToJson(
        _$LocalOptionsStateImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'seedColor': const ColorConverter().toJson(instance.seedColor),
      'useSystemSeedColor': instance.useSystemSeedColor,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
