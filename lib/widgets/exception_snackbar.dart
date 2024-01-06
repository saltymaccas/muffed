import 'package:flutter/material.dart';
import 'package:muffed/exception/exception.dart';

void showExceptionSnackBar(
    {required BuildContext context, required Object? exception}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      content: Text(
        exception.toString(),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
