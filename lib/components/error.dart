import 'package:flutter/material.dart';

import '../utils/error.dart';

class ErrorComponentTransparent extends StatelessWidget {
  const ErrorComponentTransparent({
    this.error = '',
    this.retryFunction,
    this.showErrorIcon = true,
    this.textAlign = TextAlign.center,
    super.key,
  });

  final Object? error;
  final void Function()? retryFunction;
  final bool showErrorIcon;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final errorMessage = errorObjectToString(error);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showErrorIcon)
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
        Text(
          errorMessage ?? '',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
          textAlign: textAlign,
        ),
        if (retryFunction != null)
          ElevatedButton(
            onPressed: retryFunction,
            child: Text(
              'Retry',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
      ],
    );
  }
}
