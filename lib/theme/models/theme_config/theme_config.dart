import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'theme_config.g.dart';

@JsonSerializable()
final class ThemeConfig extends Equatable {
  const ThemeConfig({
    required this.colorSchemeMode,
    required this.seedColor,
    required this.wallBasedColorScheme,
    required this.bodyTextScaleFactor,
    required this.labelTextScaleFactor,
    required this.titleTextScaleFactor,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);

  final ThemeMode colorSchemeMode;

  /// M3 dynamic colors scheme
  final bool wallBasedColorScheme;

  @JsonKey(
    fromJson: _colorFromInt,
    toJson: _colorToInt,
  )
  final Color seedColor;

  final double bodyTextScaleFactor;
  final double labelTextScaleFactor;
  final double titleTextScaleFactor;

  Map<String, dynamic> toJson() => _$ThemeConfigToJson(this);

  static Color _colorFromInt(int c) => Color(c);
  static int _colorToInt(Color c) => c.value;

  @override
  List<Object?> get props => [
    colorSchemeMode,
    seedColor,
    wallBasedColorScheme,
    bodyTextScaleFactor,
    labelTextScaleFactor,
    titleTextScaleFactor,
  ];
}
