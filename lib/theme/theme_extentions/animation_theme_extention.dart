import 'package:flutter/material.dart';

class AnimationThemeData extends ThemeExtension<AnimationThemeData> {
  const AnimationThemeData({
    this.switchInDurationSmall = const Duration(milliseconds: 250),
    this.switchOutDurationSmall = const Duration(milliseconds: 200),
    this.switchInCurveSmall = const Cubic(0.3, 0, 1, 1),
    this.switchOutCurveSmall = const Cubic(0, 0, 0, 1),
    this.switchCurveSmall = const Cubic(0.4, 0, 0.2, 1),
  });

  final Duration switchInDurationSmall;
  final Duration switchOutDurationSmall;

  final Curve switchInCurveSmall;
  final Curve switchOutCurveSmall;
  final Curve switchCurveSmall;

  @override
  ThemeExtension<AnimationThemeData> copyWith({
    Duration? switchInDurationSmall,
    Duration? switchOutDurationSmall,
    Curve? switchInCurveSmall,
    Curve? switchOutCurveSmall,
    Curve? switchCurveSmall,
  }) {
    return AnimationThemeData(
      switchOutDurationSmall:
          switchOutDurationSmall ?? this.switchOutDurationSmall,
      switchInDurationSmall:
          switchInDurationSmall ?? this.switchInDurationSmall,
      switchInCurveSmall: switchInCurveSmall ?? this.switchInCurveSmall,
      switchOutCurveSmall: switchOutCurveSmall ?? this.switchOutCurveSmall,
      switchCurveSmall: switchCurveSmall ?? this.switchCurveSmall,
    );
  }

  @override
  ThemeExtension<AnimationThemeData> lerp(
    covariant ThemeExtension<AnimationThemeData>? other,
    double t,
  ) =>
      this;
}
