import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';

final _log = Logger('NavigationBarItem');

class NavigationBarItem extends StatelessWidget {
  NavigationBarItem({
    required this.relatedBranchIndex,
    required this.icon,
    IconData? selectedIcon,
    super.key,
  }) : selectedIcon = selectedIcon ?? icon;

  final IconData icon;
  final IconData selectedIcon;
  final int relatedBranchIndex;

  @override
  Widget build(BuildContext context) {
    final MPage<Object?> currentPage = MNavigator.of(context).state.currentPage;

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          IconButton(
            isSelected: MNavigator.of(context).state.currentBranchIndex ==
                relatedBranchIndex,
            selectedIcon: Icon(
              selectedIcon,
              color: context.colorScheme().primary,
            ),
            icon: Icon(icon),
            onPressed: () {
              _log.info('Branch $relatedBranchIndex pressed');
              if (MNavigator.of(context).state.currentBranchIndex !=
                  relatedBranchIndex) {
                _log.info('Switching to branch $relatedBranchIndex');
                context.switchBranch(relatedBranchIndex);
              } else if (MNavigator.of(context).state.canPop) {
                _log.info('Popping branch $relatedBranchIndex');
                context.pop();
              }
            },
            visualDensity: VisualDensity.compact,
          ),
          if (currentPage.pageActions != null)
            _NavigationBarItemActions(pageActions: currentPage.pageActions!),
        ],
      ),
    );
  }
}

class _NavigationBarItemActions extends StatelessWidget {
  const _NavigationBarItemActions({required this.pageActions});

  final PageActions pageActions;

  @override
  Widget build(BuildContext context) {
    _log.info('Building page actions: ${pageActions.actions}');
    return ListenableBuilder(
      listenable: pageActions,
      builder: (context, child) {
        return Row(
          children: pageActions.actions,
        );
      },
    );
  }
}
