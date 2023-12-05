import 'package:flutter/material.dart';

extension BuildContextShortHand on BuildContext {
  ThemeData theme() => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
