import 'package:flutter/material.dart';
import 'package:muffed/theme/theme.dart';

extension BuildContextShortHand on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  AnimationThemeData get animationTheme =>
      Theme.of(this).extension<AnimationThemeData>()!;
}
