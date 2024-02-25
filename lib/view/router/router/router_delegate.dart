part of 'router.dart';

/// Builds the screen
class MRouterDelegate extends RouterDelegate<MPage<Object?>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MPage<Object?>> {
  MRouterDelegate() : navigator = MNavigator(initialNavigatorState);

  /// The navigator
  final MNavigator navigator;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: navigator,
      child: BlocBuilder<MNavigator, MNavigatorState>(
        bloc: navigator,
        builder: (context, state) {
          return Navigator(
            key: navigator.state.rootBranch.key,
            pages: state.rootBranch.pages,
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }

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
    navigator.pushPage(page);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey =>
      (navigator.state.rootBranch.key.currentState!.canPop())
          ? navigator.state.rootBranch.key
          : navigator.state.currentBranch.key;
}

final initialNavigatorState = MNavigatorState(
  currentBranchIndex: 0,
  rootBranch: Branch(
    [_RootPage()],
    key: GlobalKey<NavigatorState>(debugLabel: 'root'),
  ),
  branches: [
    Branch(
      [HomePage()],
      key: GlobalKey<NavigatorState>(debugLabel: 'home'),
    ),
    Branch(
      [InboxPage()],
      key: GlobalKey<NavigatorState>(debugLabel: 'inbox'),
    ),
    Branch(
      [ProfilePage()],
      key: GlobalKey<NavigatorState>(debugLabel: 'profile'),
    ),
  ],
);
