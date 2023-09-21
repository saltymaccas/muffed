import 'package:flutter/material.dart';

class ErrorComponentTransparent extends StatelessWidget {
  const ErrorComponentTransparent(
      {this.message = '', this.retryFunction, super.key});

  final Object? message;
  final void Function()? retryFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
        Text(
          message.toString(),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
          textAlign: TextAlign.center,
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
