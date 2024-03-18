import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NullableBuilder<T> extends StatelessWidget {
  NullableBuilder({
    required this.value,
    required this.placeholderValue,
    required this.builder,
    super.key,
  });

  final T? value;
  final T placeholderValue;

  final Widget Function(BuildContext context, T value) builder;

  final duration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    late final Widget widget;

    final val = value;

    if (val != null) {
      widget = builder(context, val);
    } else {
      widget = Skeletonizer(
        justifyMultiLineText: false,
        child: builder(context, placeholderValue),
      );
    }
    return AnimatedSwitcher(
      duration: duration,
      child: widget,
    );
  }
}
