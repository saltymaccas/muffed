import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, {String text = 'Error'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
    ),
  );
}
