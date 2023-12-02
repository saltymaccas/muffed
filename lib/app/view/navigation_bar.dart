import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/app/router/extensions.dart';
import 'package:muffed/shorthands.dart';

import '../router/models.dart';
import '../router/navigator.dart';

class NavigationItemConfig {
  const NavigationItemConfig({
    required this.icon,
    required this.selectedIcon,
  });

  final IconData icon;
  final IconData selectedIcon;
}

class MNavigationBar extends StatelessWidget {
  const MNavigationBar(this.itemConfigs, {super.key});

  final List<NavigationItemConfig> itemConfigs;

  List<Widget> generateItems(BuildContext context, int currentBranchIndex) {
    final items = <Widget>[];
    for (int i = 0; i < itemConfigs.length; i++) {
      items.add(
        _NavigationBarItem(
          isSelected: i == currentBranchIndex,
          icon: this.itemConfigs[i].icon,
          onPressed: () => context.switchBranch(i),
          selectedIcon: this.itemConfigs[i].selectedIcon,
        ),
      );
    }
    return items;
  }

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
              children: generateItems(context, state.currentBranchIndex),
            ),
          ),
        );
      },
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    required this.isSelected,
    required this.icon,
    required this.onPressed,
    IconData? selectedIcon,
  }) : selectedIcon = selectedIcon ?? icon;

  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: IconButton(
        isSelected: isSelected,
        selectedIcon: Icon(
          selectedIcon,
          color: context.colorScheme().primary,
        ),
        icon: Icon(icon),
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
