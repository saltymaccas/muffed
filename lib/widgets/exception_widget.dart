import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muffed/theme/models/extentions.dart';

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({required this.exception, this.retryCallback,super.key});

  final Object exception;
  final void Function()? retryCallback;

  @override
  Widget build(BuildContext context) {
    final errorMessages = exception.toString();
    return Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(errorMessages, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.colorScheme.error)),
        if (retryCallback != null) ElevatedButton(onPressed: retryCallback, child: Text('Retry')),
      ],
    ),);
  }
}