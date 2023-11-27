import 'package:flutter/material.dart';

extension BuildContextShortHand on BuildContext {
  ThemeData theme() => Theme.of(this);

  TextTheme textTheme() => Theme.of(this).textTheme;

  ColorScheme colorScheme() => Theme.of(this).colorScheme;
}

extension StringShortHand on String? {
  int? parseInt() {
    if (this != null && this!.isNotEmpty) {
      return int.parse(this!);
    }
    return null;
  }
}
