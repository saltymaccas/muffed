import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/navigation_bar/navigation_bar.dart';
import 'package:muffed/router/router.dart';

class MNavigationBar extends StatelessWidget {
  const MNavigationBar(this.items, {super.key});

  final List<NavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MNavigator, MNavigatorState>(
      builder: (context, state) {
        return Material(
          elevation: 2,
          color: Theme.of(context).colorScheme.surface,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                items.length,
                (index) => items[index].build(context),
              ),
            ),
          ),
        );
      },
    );
  }
}
