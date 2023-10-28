import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/profile_page/account_switcher.dart';

import 'bloc/bloc.dart';

const Duration _animDur = Duration(milliseconds: 500);
const int _animInterval = 200;
const Curve _animCurve = Curves.easeInOutCubic;

/// The bar that is displayed at the bottom of the app
///
/// Items are the main buttons, actions are the buttons that come out
/// of the items.
class DynamicNavigationBar extends StatelessWidget {
  /// initialize
  const DynamicNavigationBar({required this.onItemTapped, super.key});

  /// When an item item is tapped, an item being the main navigation button
  /// on the bar e.g. Home, Inbox User
  final void Function(int index, BuildContext? currentContext) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      child: SizedBox(
        height: 60,
        child: BlocBuilder<DynamicNavigationBarBloc, DynamicNavigationBarState>(
          builder: (context, state) {
            final items = [
              _DynamicNavigationBarItem(
                itemIndex: 0,
                icon: IconButton(
                  onPressed: () {
                    onItemTapped(
                      0,
                      (state.pageStackInfo[0]!.isNotEmpty)
                          ? state.pageStackInfo[0]!.last.context
                          : null,
                    );
                  },
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  isSelected: state.selectedItemIndex == 0,
                ),
                selected: state.selectedItemIndex == 0,
              ),
              _DynamicNavigationBarItem(
                itemIndex: 1,
                icon: IconButton(
                  onPressed: () {
                    onItemTapped(
                      1,
                      (state.pageStackInfo[1]!.isNotEmpty)
                          ? state.pageStackInfo[1]!.last.context
                          : null,
                    );
                  },
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.inbox_outlined),
                  selectedIcon: const Icon(Icons.inbox),
                  isSelected: state.selectedItemIndex == 1,
                ),
                selected: state.selectedItemIndex == 1,
              ),
              _DynamicNavigationBarItem(
                icon: GestureDetector(
                  onLongPress: () {
                    showAccountSwitcher(context);
                  },
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      onItemTapped(
                        2,
                        (state.pageStackInfo[2]!.isNotEmpty)
                            ? state.pageStackInfo[2]!.last.context
                            : null,
                      );
                    },
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    isSelected: state.selectedItemIndex == 2,
                  ),
                ),
                selected: state.selectedItemIndex == 2,
                itemIndex: 2,
              ),
            ];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                return AnimatedSize(
                  curve: _animCurve,
                  duration: _animDur,
                  child: items[index],
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _DynamicNavigationBarItem extends StatefulWidget {
  final Widget icon;
  final bool selected;
  final int itemIndex;

  const _DynamicNavigationBarItem({
    required this.icon,
    required this.selected,
    required this.itemIndex,
  });

  @override
  State<_DynamicNavigationBarItem> createState() =>
      _DynamicNavigationBarItemState();
}

class _DynamicNavigationBarItemState extends State<_DynamicNavigationBarItem> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DynamicNavigationBarBloc>();

    /// Whether the page has actions.
    ///
    /// This is used to make sure the spacer in between the item and the actions
    /// is only shown when it should be
    late final bool hasActions;

    final LemmyAccountData? loadedAccount = null;

    if (widget.selected) {
      if (loadedAccount !=
          context.watch<GlobalBloc>().getSelectedLemmyAccount()) {}
    }

    if (bloc.state.pageStackInfo[widget.itemIndex]!.isNotEmpty) {
      if (bloc.state.pageStackInfo[widget.itemIndex]!.last.actions.isNotEmpty) {
        hasActions = true;
      } else {
        hasActions = false;
      }
    } else {
      hasActions = false;
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedSize(
        reverseDuration: _animDur,
        curve: _animCurve,
        duration: _animDur,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.icon,
            AnimatedSize(
              curve: _animCurve,
              duration: _animDur,
              child: (widget.selected && hasActions)
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width: 2,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ).animate().fade(
                              duration: _animDur,
                              curve: _animCurve,
                              begin: 0,
                            ),
                        AnimatedSize(
                          duration: _animDur,
                          curve: _animCurve,
                          child: AnimatedSwitcher(
                            duration: _animDur,
                            reverseDuration: _animDur,
                            switchInCurve: _animCurve,
                            switchOutCurve: _animCurve,
                            child: Row(
                              // key needs to be set so the actions get animated in when page
                              // is pushed
                              key: Key(
                                  'actionRow ${bloc.state.pageStackInfo[widget.itemIndex]!.length} ${widget.itemIndex}'),
                              children: bloc
                                  .state
                                  .pageStackInfo[widget.itemIndex]!
                                  .last
                                  .actions,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that wraps around a page that sets the information of the page
/// which gets passed into the [DynamicNavigationBar]
class SetPageInfo extends StatefulWidget {
  /// initialize
  const SetPageInfo({
    required this.indexOfRelevantItem,
    required this.actions,
    required this.child,
    super.key,
  });

  /// The index of the item that the information will be added to.
  ///
  /// Basically just set this to the base page index that the page is on.
  ///
  /// *Fuck this shit is hard to explain properly
  final int indexOfRelevantItem;

  /// The actions that will appear next to the item when it is on the page
  final List<Widget> actions;

  /// the page itself
  final Widget child;

  @override
  State<SetPageInfo> createState() => _SetPageInfoState();
}

class _SetPageInfoState extends State<SetPageInfo> {
  late DynamicNavigationBarBloc _bloc;
  final List<Widget> animatedActions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<DynamicNavigationBarBloc>();
  }

  @override
  void initState() {
    super.initState();

    _bloc = context.read<DynamicNavigationBarBloc>();

    for (var i = 0; i < widget.actions.length; i++) {
      final Widget action = widget.actions[i];
      animatedActions.add(
        action
            .animate(autoPlay: true)
            .slideY(
              duration: _animDur,
              curve: _animCurve,
              begin: 3,
              delay: Duration(milliseconds: _animInterval * i),
              end: 0,
            )
            .fadeIn(
              duration: _animDur,
              begin: 0,
              curve: _animCurve,
              delay: Duration(milliseconds: _animInterval * i),
            ),
      );
    }

    _bloc.add(
      PageAdded(
        PageInfo(context: context, actions: animatedActions),
        widget.indexOfRelevantItem,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.add(PageRemoved(widget.indexOfRelevantItem));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
