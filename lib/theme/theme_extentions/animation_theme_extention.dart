import 'package:flutter/material.dart';

class AnimationThemeData extends ThemeExtension<AnimationThemeData> {
  const AnimationThemeData({
    this.switchInDurationShort = const Duration(milliseconds: 300),
    this.switchOutDurationShort = const Duration(milliseconds: 200),
    this.switchInDuration = const Duration(milliseconds: 400),
    this.switchOutDuration = const Duration(milliseconds: 300),
    this.switchDuration = const Duration(milliseconds: 500),
    this.fadeCurve = Curves.easeInOut,
    this.acelerateCurve = const Cubic(0.3, 0.0, 0.8, 0.15),
    this.decelerateCurve = const Cubic(0.05, 0.7, 0.1, 1.0),
    this.standeredCurve = Curves.easeInOutCubicEmphasized,
  });

  final Duration switchInDurationShort;
  final Duration switchOutDurationShort;

  final Duration switchInDuration;
  final Duration switchOutDuration;
  final Duration switchDuration;

  final Curve fadeCurve;

  final Curve acelerateCurve;
  final Curve decelerateCurve;
  final Curve standeredCurve;

  @override
  ThemeExtension<AnimationThemeData> copyWith({
    Duration? switchInDurationSmall,
    Duration? switchOutDurationSmall,
    Duration? switchInDuration,
    Duration? switchOutDuration,
    Duration? switchDuration,
    Curve? fadeCurve,
    Curve? switchInCurveSmall,
    Curve? switchOutCurveSmall,
    Curve? switchCurveSmall,
  }) {
    return AnimationThemeData(
      switchOutDurationShort:
          switchOutDurationSmall ?? this.switchOutDurationShort,
      switchInDurationShort:
          switchInDurationSmall ?? this.switchInDurationShort,
      switchInDuration: switchInDuration ?? this.switchInDuration,
      switchOutDuration: switchOutDuration ?? this.switchOutDuration,
      switchDuration: switchDuration ?? this.switchDuration,
      fadeCurve: fadeCurve ?? this.fadeCurve,
      acelerateCurve: switchInCurveSmall ?? this.acelerateCurve,
      decelerateCurve: switchOutCurveSmall ?? this.decelerateCurve,
      standeredCurve: switchCurveSmall ?? this.standeredCurve,
    );
  }

  @override
  ThemeExtension<AnimationThemeData> lerp(
    covariant ThemeExtension<AnimationThemeData>? other,
    double t,
  ) =>
      this;
}
