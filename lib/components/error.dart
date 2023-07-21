import 'package:flutter/material.dart';

class ErrorComponentTransparent extends StatelessWidget {
  const ErrorComponentTransparent({this.message = '', super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline,color: Colors.red,),
        Text(message, style: TextStyle(color: Colors.red),)
      ],
    );
  }
}
