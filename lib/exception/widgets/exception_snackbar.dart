import 'package:flutter/material.dart';
import 'package:muffed/exception/exception.dart';

void showExceptionSnackBar(BuildContext context, MException exception) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      content: Text(
        exception.exceptionToString(),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
