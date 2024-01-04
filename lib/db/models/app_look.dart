import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_look.g.dart';

@JsonSerializable()
final class AppLookModel extends Equatable {
  const AppLookModel({
    required this.colorSchemeMode,
    required this.seedColor,
    required this.wallBasedColorScheme,
    required this.bodyTextScaleFactor,
    required this.labelTextScaleFactor,
    required this.titleTextScaleFactor,
  });

  factory AppLookModel.fromJson(Map<String, dynamic> json) =>
      _$AppLookModelFromJson(json);

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

  Map<String, dynamic> toJson() => _$AppLookModelToJson(this);

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
