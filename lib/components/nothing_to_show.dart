import 'package:flutter/material.dart';

class NothingToShow extends StatelessWidget {
  const NothingToShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          //color: Theme.of(context).colorScheme.outlineVariant,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Nothing to show',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      ),
    );
  }
}
