part of 'router.dart';

/// Builds the screen
class MRouterDelegate extends RouterDelegate<MPage<Object?>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MPage<Object?>> {
  MRouterDelegate()
      : navigator = MNavigator(
          MNavigatorState(
            currentBranchIndex: 0,
            branches: [
              Branch([HomePage()]),
              Branch(const [InboxPage()]),
              Branch(const [ProfilePage()])
            ],
            rootBranch: Branch(const []),
          ),
        );

  /// The navigator
  final MNavigator navigator;

  @override
  Widget build(BuildContext context) {
    navigator.pushToRootBranch(_RootPage(navigator));

    return BlocProvider.value(
      value: navigator,
      child: BlocBuilder<MNavigator, MNavigatorState>(
        bloc: navigator,
        builder: (context, state) {
          return Navigator(
            pages: state.rootBranch.pages,
            onPopPage: (route, result) {
              log('Something attempted to pop a page from root navigator');
              return false;
            },
          );
        },
      ),
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey =>
      navigator.state.currentBranch.key;

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

class _RootPage extends MPage<void> {
  const _RootPage(this.navigator);

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
}
