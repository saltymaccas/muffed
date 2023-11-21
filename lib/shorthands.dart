import 'package:flutter/material.dart';

extension BuildContextShortHand on BuildContext {
  ThemeData theme() => Theme.of(this);

  TextTheme textTheme() => Theme.of(this).textTheme;

  ColorScheme colorScheme() => Theme.of(this).colorScheme;
}

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
