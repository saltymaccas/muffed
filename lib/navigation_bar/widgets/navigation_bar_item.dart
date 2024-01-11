import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';

final _log = Logger('NavigationBarItem');

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
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
    return BlocBuilder<MNavigator, MNavigatorState>(
      builder: (context, navState) {
        final onBranch = navState.currentBranchIndex == relatedBranchIndex;
        final pageActions =
            navState.branches[relatedBranchIndex].top.pageActions;
        return Builder(
          builder: (context) {
            final actions = pageActions.actions;
            return Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 40),
                child: AnimatedSize(
                  duration: context.animationTheme.durLong,
                  curve: context.animationTheme.empasizedCurve,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(icon),
                        selectedIcon: Icon(
                          selectedIcon,
                          color: context.colorScheme.primary,
                        ),
                        isSelected: onBranch,
                        onPressed: () {
                          if (!onBranch) {
                            context.switchBranch(relatedBranchIndex);
                          } else {
                            context.maybePopRouteFromCurrentBranch();
                          }
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                      if (onBranch)
                      Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: onBranch ? 1 : 0,
                        child: _ActionsRowFactory(
                          key: ValueKey(relatedBranchIndex),
                          onBranch: onBranch,
                          actions: actions,
                          alignment: Alignment.centerLeft,
                          actionInCurve:
                              context.animationTheme.empasizedDecelerateCurve,
                          actionInDuration: context.animationTheme.durMed1,
                          actionOutCurve:
                              context.animationTheme.empasizedAcelerateCurve,
                          actionOutDuration: context.animationTheme.durMed1,
                          sizeAnimCurve: context.animationTheme.empasizedCurve,
                          sizeAnimDuration: context.animationTheme.durLong,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Creates a row of actions, when a differnt
/// list of actions is parsed in a new row is created and added on top of the
/// stack and the last rows are ordered to remove themselves
class _ActionsRowFactory extends StatefulWidget {
  const _ActionsRowFactory({
    required this.actions,
    required this.onBranch,
    required this.alignment,
    required this.actionInCurve,
    required this.actionInDuration,
    required this.actionOutCurve,
    required this.actionOutDuration,
    required this.sizeAnimCurve,
    required this.sizeAnimDuration,
    super.key,
  });

  final List<Widget>? actions;
  final bool onBranch;

  final AlignmentGeometry alignment;

  final Curve sizeAnimCurve;
  final Duration sizeAnimDuration;

  final Curve actionInCurve;
  final Curve actionOutCurve;

  final Duration actionInDuration;
  final Duration actionOutDuration;

  @override
  State<_ActionsRowFactory> createState() => _ActionsRowFactoryState();
}

class _ActionsRowFactoryState extends State<_ActionsRowFactory> {
  /// Action Row meaning a row of actions that the page has declared
  late List<_ActionRow> actionRows;

  /// stores that are animating out temporarily
  List<_ActionRow> rowsBeingRemoved = [];

  Future<void> removeFromActionRow(int i) async {
    final key = actionRows[i].key;
    if (key is GlobalKey<__ActionRowState>) {
      rowsBeingRemoved.add(actionRows[i]);
      final removeIndex = rowsBeingRemoved.length - 1;
      actionRows.removeAt(i);
      await key.currentState!.animateOut();
      rowsBeingRemoved.removeAt(removeIndex);
    } else {
      throw Exception('Key is not a GlobalKey<__ActionRowState>');
    }
  }

  Future<void> appendActionRow(List<Widget> actionList) async {
    setState(() {
      actionRows.add(
        _ActionRow(
          key: GlobalKey<__ActionRowState>(),
          actions: actionList,
          inCurve: widget.actionInCurve,
          inDuration: widget.actionInDuration,
          outCurve: widget.actionOutCurve,
          outDuration: widget.actionOutDuration,
          alignment: Alignment.centerLeft,
        ),
      );
    });
    if (actionRows.length > 1) {
      await Future.wait(
        List.generate(actionRows.length - 1, removeFromActionRow),
      );
    }
  }

  @override
  void initState() {
    actionRows = [];
    appendActionRow(widget.actions ?? []);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ActionsRowFactory oldWidget) {
    if (
        widget.actions != null &&
        // Only runs if on branch as a quick fix to it animating when branch
        // changes, this should be changed to identify if the actions are
        // the same or not
        widget.onBranch) {
      appendActionRow(widget.actions!);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.centerLeft,
      duration: widget.sizeAnimDuration,
      curve: widget.sizeAnimCurve,
      child: Stack(
        children: actionRows + rowsBeingRemoved,
      ),
    );
  }
}

/// A row of actions that are able to animate themselves out,
class _ActionRow extends StatefulWidget {
  const _ActionRow({
    required this.actions,
    required this.inCurve,
    required this.inDuration,
    required this.outCurve,
    required this.outDuration,
    required this.alignment,
    super.key,
  });

  final List<Widget> actions;

  final Curve inCurve;
  final Duration inDuration;

  final Curve outCurve;
  final Duration outDuration;

  final AlignmentGeometry alignment;

  @override
  State<_ActionRow> createState() => __ActionRowState();
}

class __ActionRowState extends State<_ActionRow> with TickerProviderStateMixin {
  @override
  void initState() {
    const animInterval = 200;
    final animatedActions = List.generate(
      widget.actions.length,
      // Make each widget slide in individually
      (index) => widget.actions[index].animate(autoPlay: true).slideY(
            duration: widget.inDuration,
            curve: widget.inCurve,
            begin: 3,
            delay: Duration(milliseconds: animInterval * index),
            end: 0,
          ),
    );
    children = animatedActions;

    /// Animates fade and size, in and out for the whole row, 1 = in, 0 = out
    animationController = AnimationController(
      vsync: this,
      value: 0,
      duration: widget.inDuration,
      reverseDuration: widget.outDuration,
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: widget.inCurve,
      reverseCurve: widget.outCurve,
    )..addListener(() {
        setState(() {});
      });

    animationController.animateTo(1);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> animateOut() async {
    setState(() {
      isAnimatingOut = true;
    });
    await animationController.animateBack(0);
  }

  late final List<Widget> children;
  late final AnimationController animationController;
  late final CurvedAnimation animation;

  bool isAnimatingOut = false;

  @override
  Widget build(BuildContext context) {
    final divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 2,
        height: 10,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );

    return Align(
      // The width is set to 0 so the parent animated size will ignore it's
      // width
      alignment: Alignment.centerLeft,
      widthFactor: isAnimatingOut ? 0 : 1,
      child: Opacity(
        opacity: animation.value,
        child: Row(
          children: (children.isNotEmpty) ? [divider, ...children] : [],
        ),
      ),
    );
  }
}
