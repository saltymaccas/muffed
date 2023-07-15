import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bloc/bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DynamicNavigationBar extends StatelessWidget {
  const DynamicNavigationBar({required this.onTap, super.key});

  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      child: Container(
        height: 60,
        child: BlocBuilder<DynamicNavigationBarBloc, DynamicNavigationBarState>(
          builder: (context, state) {
            List<DynamicNavigationBarItem> items = [
              DynamicNavigationBarItem(
                itemIndex: 0,
                icon: IconButton(
                  onPressed: () {
                    onTap(0);
                  },
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  isSelected: state.selectedItemIndex == 0,
                ),
                selected: state.selectedItemIndex == 0,
              ),
              DynamicNavigationBarItem(
                itemIndex: 1,
                icon: IconButton(
                  onPressed: () {
                    onTap(1);
                  },
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.inbox_outlined),
                  selectedIcon: Icon(Icons.inbox),
                  isSelected: state.selectedItemIndex == 1,
                ),
                selected: state.selectedItemIndex == 1,
              ),
            ];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                return items[index];
              }),
            );
          },
        ),
      ),
    );
  }
}

class DynamicNavigationBarItem extends StatefulWidget {
  final Widget icon;
  final bool selected;
  final int itemIndex;

  const DynamicNavigationBarItem(
      {required this.icon,
      required this.selected,
      required this.itemIndex,
      super.key});

  @override
  State<DynamicNavigationBarItem> createState() =>
      _DynamicNavigationBarItemState();
}

class _DynamicNavigationBarItemState extends State<DynamicNavigationBarItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        child: Row(
          children: [
            widget.icon,
            if (widget.selected &&
                context
                    .read<DynamicNavigationBarBloc>()
                    .state
                    .actions[widget.itemIndex]!
                    .isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 2,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline),
                ),
              ),
            if (widget.selected &&
                context
                    .read<DynamicNavigationBarBloc>()
                    .state
                    .actions[widget.itemIndex]!
                    .isNotEmpty)
              Row(
                children: context
                    .read<DynamicNavigationBarBloc>()
                    .state
                    .actions[widget.itemIndex]!
                    .last,
              )
          ],
        ));
  }
}

class BottomNavigationBarActions extends StatefulWidget {
  const BottomNavigationBarActions(
      {required this.itemIndex,
      required this.actions,
      required this.child,
      super.key});

  final int itemIndex;
  final List<Widget> actions;
  final Widget child;

  @override
  State<BottomNavigationBarActions> createState() =>
      _BottomNavigationBarActionsState();
}

class _BottomNavigationBarActionsState
    extends State<BottomNavigationBarActions> {
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
      animatedActions.add(action
          .animate(autoPlay: true)
          .slideY(
              duration: 500.ms,
              curve: Curves.easeOutCubic,
              begin: -3,
              delay: Duration(milliseconds: 200 * i),
              end: 0,));
    }

    _bloc.add(AddActions(animatedActions, widget.itemIndex));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.add(RemoveActions(widget.itemIndex));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
