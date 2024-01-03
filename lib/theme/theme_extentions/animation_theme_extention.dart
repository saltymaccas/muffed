import 'package:flutter/material.dart';

class AnimationThemeData extends ThemeExtension<AnimationThemeData> {
  const AnimationThemeData({
    this.durMed1 = const Duration(milliseconds: 300),
    this.durShort = const Duration(milliseconds: 200),
    this.durMed2 = const Duration(milliseconds: 400),
    this.durLong = const Duration(milliseconds: 500),
    this.empasizedAcelerateCurve = const Cubic(0.3, 0, 0.8, 0.15),
    this.empasizedDecelerateCurve = const Cubic(0.05, 0.7, 0.1, 1),
    this.empasizedCurve = Curves.easeInOutCubicEmphasized,
  });

  final Duration durMed1;
  final Duration durShort;

  final Duration durMed2;
  final Duration durLong;

  final Curve empasizedAcelerateCurve;
  final Curve empasizedDecelerateCurve;
  final Curve empasizedCurve;

  @override
  ThemeExtension<AnimationThemeData> copyWith() {
    return const AnimationThemeData();
  }

  @override
  ThemeExtension<AnimationThemeData> lerp(
    covariant ThemeExtension<AnimationThemeData>? other,
    double t,
  ) =>
      this;
}
