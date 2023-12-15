part of 'router.dart';

/// Builds the screen
class MRouterDelegate extends RouterDelegate<MPage<Object?>>
    with ChangeNotifier {
  MRouterDelegate(this.navigator);

  /// The navigator
  final MNavigator navigator;

  @override
  Widget build(BuildContext context) {
    navigator
        .pushToRootBranch(_RootPage(navigator, key: const ValueKey('root')));

    return BlocProvider.value(
      value: navigator,
      child: BlocBuilder<MNavigator, MNavigatorState>(
        bloc: navigator,
        builder: (context, state) {
          return Navigator(
            key: navigator.state.rootBranch.key,
            pages: state.rootBranch.pages,
            onPopPage: (route, result) {
              return false;
            },
          );
        },
      ),
    );
  }

  /// What to do when new route gets pushed by operating system
  @override
  Future<void> setNewRoutePath(MPage<Object?> page) async {
    navigator.push(page);
  }

  @override
  Future<bool> popRoute() {
    if (navigator.state.canPop) {
      navigator.maybePop();
      return SynchronousFuture(true);
    } else {
      return SynchronousFuture(false);
    }
  }
}

class _RootPage extends MPage<void> {
  const _RootPage(this.navigator, {super.key});

  final MNavigator navigator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _NestedBranchView(navigator),
      bottomNavigationBar: const MNavigationBar(),
    );
  }
}

/// Builds the nested branches in an indexed stack
class _NestedBranchView extends StatelessWidget {
  const _NestedBranchView(
    this.navigator,
  );

  final MNavigator navigator;

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackItems =
        List.generate(navigator.state.branches.length, _buildBranch);

    return IndexedStack(
      index: navigator.state.currentBranchIndex,
      children: stackItems,
    );
  }

  Widget _buildBranch(int index) {
    final branch = navigator.state.branches[index];
    final isCurrent = index == navigator.state.currentBranchIndex;

    return Offstage(
      offstage: !isCurrent,
      child: TickerMode(
        enabled: isCurrent,
        child: HeroControllerScope(
          controller: MaterialApp.createMaterialHeroController(),
          child: Navigator(
            key: branch.key,
            pages: branch.pages,
            onPopPage: _onPopPage,
          ),
        ),
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (navigator.state.canPop) {
      navigator.maybePop();
      return true;
    } else {
      return false;
    }
  }
}
