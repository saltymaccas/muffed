import 'package:flutter/material.dart';
import 'package:muffed/exception/exception.dart';

class _ExceptionWidget extends StatelessWidget {
  const _ExceptionWidget({
    required this.exception,
    this.retryFunction,
    this.showErrorIcon = true,
    this.textAlign = TextAlign.center,
    super.key,
  });

  final MException exception;
  final void Function()? retryFunction;
  final bool showErrorIcon;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showErrorIcon)
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
        Text(
          exception.exceptionToString(),
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
          ),
      ],
    );
  }
}
