import 'package:flutter/material.dart';

class IconButtonLoading extends StatelessWidget {
  const IconButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

class IconButtonFailure extends StatelessWidget {
  const IconButtonFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.error_outline,
        color: Theme.of(context).colorScheme.error,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

class IconButtonInitial extends StatelessWidget {
  const IconButtonInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: () {},
      icon: const SizedBox(
        height: 15,
        width: 15,
      ),
    );
  }
}
