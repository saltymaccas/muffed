import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bloc/bloc.dart';

class DynamicNavigationBar extends StatelessWidget {
  const DynamicNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 2,
        child: Container(
            height: 60,
            child: BlocBuilder<DynamicNavigationBarBloc,
                DynamicNavigationBarState>(
              builder: (context, state) {
                List<DynamicNavigationBarItem> items = [
                  DynamicNavigationBarItem(
                      icon: IconButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        isSelected: state.selectedItemIndex == 0,
                      ),
                      selected: state.selectedItemIndex == 0),
                  DynamicNavigationBarItem(
                      icon: IconButton(
                        onPressed: () {
                          context.go('/inbox');
                        },
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.inbox_outlined),
                        selectedIcon: Icon(Icons.inbox),
                        isSelected: state.selectedItemIndex == 1,
                      ),
                      selected: state.selectedItemIndex == 1),
                ];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(items.length, (index) {
                    return items[index];
                  }),
                );
              },
            )));
  }
}

class DynamicNavigationBarItem extends StatefulWidget {
  final Widget icon;
  final List<Widget>? subItems;
  final bool selected;

  const DynamicNavigationBarItem(
      {required this.icon, this.subItems, required this.selected, super.key});

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
          children: [widget.icon],
        ));
  }
}
