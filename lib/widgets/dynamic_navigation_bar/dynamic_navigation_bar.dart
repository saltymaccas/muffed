import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/router/extensions.dart';
import 'package:muffed/router/navigator.dart';

import '../../router/models.dart';

class DynamicNavigationBar extends StatelessWidget {
  const DynamicNavigationBar({super.key});

  List<Widget> generateItems(BuildContext context, List<Branch> branches) {
    final items = <Widget>[];
    for (int i = 0; i < branches.length; i++) {
      items.add(
        IconButton(
          onPressed: () {
            context.switchBranch(i);
          },
          icon: Icon(Icons.home),
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
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: generateItems(context, state.branches),
            ),
          ),
        );
      },
    );
  }
}
