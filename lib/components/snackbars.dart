import 'package:flutter/material.dart';

import '../utils/error.dart';

void showErrorSnackBar(BuildContext context, {Object? error = 'Error'}) {
  final errorMessage = errorObjectToString(error);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      content: Text(
        errorMessage ?? 'Error',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showInfoSnackBar(BuildContext context, {String text = ''}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
