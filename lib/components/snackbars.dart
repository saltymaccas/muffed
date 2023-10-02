import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, {String text = 'Error'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      content: Text(
        text,
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
