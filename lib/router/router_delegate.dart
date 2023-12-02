import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/router/navigator.dart';
import 'package:muffed/widgets/page.dart';

import 'models.dart';

/// Builds the pages based on the state of the navigator
class MRouterDelegate extends RouterDelegate<MPage>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MPage> {
  MRouterDelegate(this.navigator);

  final MNavigator navigator;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: navigator.state.currentBranch.pages,
      onPopPage: _onPopPage,
    );

    BlocBuilder<MNavigator, MNavigatorState>(
      bloc: navigator,
      builder: (context, state) {
        return Navigator(
          key: state.currentKey,
          pages: state.currentBranch.pages,
          onPopPage: _onPopPage,
        );

        //   IndexedStack(
        //   index: state.currentBranch,
        //   children: [
        //     for (final branch in state.branches)
        //       Navigator(
        //         key: branch.key,
        //         pages: List.of(branch.pages),
        //         onPopPage: _onPopPage,
        //       ),
        //   ],
        // );
      },
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (navigator.state.canPop) {
      navigator.pop();
      return true;
    } else {
      return false;
    }
  }

  /// called by router when it detects it may have changed because of a rebuild
  /// necessary for backward and forward buttons to work properly
  @override
  MPage? get currentConfiguration => navigator.state.currentPage;

  /// What to do when new route gets pushed by operating system
  @override
  Future<void> setNewRoutePath(MPage page) async {
    navigator.push(page);
  }
}
