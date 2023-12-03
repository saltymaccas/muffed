import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/router/router.dart';

/// Builds the nested screen based on the state of the navigator
class MRouterDelegate extends RouterDelegate<MPage<Object?>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MPage<Object?>> {
  MRouterDelegate(this.navigator);

  /// The navigator
  final MNavigator navigator;

  @override
  GlobalKey<NavigatorState>? get navigatorKey =>
      navigator.state.currentBranch.key;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MNavigator, MNavigatorState>(
      bloc: navigator,
      builder: (context, state) {
        return IndexedStack(
          index: state.currentBranchIndex,
          children: [
            for (final branch in state.branches)
              HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: Navigator(
                  key: branch.key,
                  pages: branch.pages,
                  onPopPage: _onPopPage,
                ),
              ),
          ],
        );
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
  MPage<Object?>? get currentConfiguration => navigator.state.currentPage;

  /// What to do when new route gets pushed by operating system
  @override
  Future<void> setNewRoutePath(MPage<Object?> page) async {
    navigator.push(page);
  }
}
