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
      builder: (context, state) {
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
                  color: context.colorScheme.primary,
                ),
                icon: Icon(icon),
                onPressed: () {
                  _log.info('Branch $relatedBranchIndex pressed');
                  if (MNavigator.of(context).state.currentBranchIndex !=
                      relatedBranchIndex) {
                    _log.info('Switching to branch $relatedBranchIndex');
                    context.switchBranch(relatedBranchIndex);
                  } else {
                    context.maybePopRouteFromCurrentBranch();
                  }
                },
                visualDensity: VisualDensity.compact,
              ),
              if (state.currentBranchIndex == relatedBranchIndex)
                AnimatedSize(
                  duration: context.animationTheme.switchDuration,
                  curve: context.animationTheme.standeredCurve,
                  child: _NavigationBarItemActions(
                    key: ValueKey(relatedBranchIndex),
                    pageActions:
                        state.branches[relatedBranchIndex].top.pageActions,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationBarItemActions extends StatelessWidget {
  const _NavigationBarItemActions({required this.pageActions, super.key});

  final PageActions? pageActions;

  int get _animInterval => 200;

  @override
  Widget build(BuildContext context) {
    List<Widget> attachAnimations(List<Widget> widgets) => List.generate(
          widgets.length,
          (index) => widgets[index]
              .animate(autoPlay: true)
              .slideY(
                duration: context.animationTheme.switchInDuration,
                curve: context.animationTheme.decelerateCurve,
                begin: 3,
                delay: Duration(milliseconds: _animInterval * index),
                end: 0,
              )
              .fadeIn(
                duration: context.animationTheme.switchInDuration,
                begin: 0,
                curve: context.animationTheme.decelerateCurve,
                delay: Duration(milliseconds: _animInterval * index),
              ),
        );
    if (pageActions != null) {
      return _ShouldAnimate(
        animate: true,
        child: ListenableBuilder(
          listenable: pageActions!,
          builder: (context, child) {
            return _ShouldAnimate(
              animate: true,
              child: Row(
                children: [
                  AnimatedCrossFade(
                    firstChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 2,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    secondChild: const SizedBox(),
                    crossFadeState: (pageActions!.actions == null ||
                            pageActions!.actions != null &&
                                pageActions!.actions!.isNotEmpty)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: context.animationTheme.switchDuration,
                  ),
                  AnimatedSwitcher(
                    duration: context.animationTheme.switchDuration,
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          if (previousChildren.isNotEmpty)
                            _ShouldAnimate(
                              animate: false,
                              child: SizedOverflowBox(
                                alignment: Alignment.centerLeft,
                                size: Size.zero,
                                child: previousChildren[0],
                              ),
                            ),
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    child: Builder(
                      key: ObjectKey(pageActions),
                      builder: (context) {
                        final animate = _ShouldAnimate.of(context).animate;

                        final actions = pageActions!.actions ?? [];

                        if (animate) {
                          return Row(
                            children: attachAnimations(actions),
                          );
                        } else {
                          return Row(children: actions);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class _ShouldAnimate extends InheritedWidget {
  const _ShouldAnimate({
    required this.animate,
    required super.child,
  });

  final bool animate;

  static _ShouldAnimate? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ShouldAnimate>();
  }

  static _ShouldAnimate of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No _ShouldAnimate found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_ShouldAnimate oldWidget) => false;
}
