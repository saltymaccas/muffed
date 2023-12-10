import 'package:flutter/material.dart';

void showInfoSnackBar(BuildContext context, {String text = ''}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 5,
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
