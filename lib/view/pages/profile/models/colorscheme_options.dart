import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:muffed/domain/local_options/bloc.dart';

enum ColorSchemeOptions {
  purple(Colors.purple, 'lavender'),
  red(Colors.red, 'blaze'),
  blue(Colors.blue, 'sky'),
  green(Colors.green, 'lawn'),
  custom(null, 'custom'),
  system(null, 'copy system');

  const ColorSchemeOptions(this.color, this.humaneString);

  final Color? color;
  final String humaneString;

  static ColorSchemeOptions fromLocalOptionsState(LocalOptionsState state) {
    if (state.useSystemSeedColor) {
      return ColorSchemeOptions.system;
    }

    final v = state.seedColor.value;

    if (v == ColorSchemeOptions.purple.color?.value)
      return ColorSchemeOptions.purple;
    if (v == ColorSchemeOptions.red.color?.value) return ColorSchemeOptions.red;
    if (v == ColorSchemeOptions.blue.color?.value)
      return ColorSchemeOptions.blue;
    if (v == ColorSchemeOptions.green.color?.value)
      return ColorSchemeOptions.green;

    return ColorSchemeOptions.custom;
  }

  (bool, Color) toLocalOptionsState() {
    switch (this) {
      case ColorSchemeOptions.system:
        return (true, Colors.blue);
      case ColorSchemeOptions.purple:
        return (false, ColorSchemeOptions.purple.color!);
      case ColorSchemeOptions.red:
        return (false, ColorSchemeOptions.red.color!);
      case ColorSchemeOptions.blue:
        return (false, ColorSchemeOptions.blue.color!);
      case ColorSchemeOptions.green:
        return (false, ColorSchemeOptions.green.color!);
      case ColorSchemeOptions.custom:
        return (false, Colors.purple);
    }
  }
}

