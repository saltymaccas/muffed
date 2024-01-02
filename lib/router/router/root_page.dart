part of 'router.dart';

class _RootPage extends MPage<void> {
  _RootPage();

  @override
  Widget build(BuildContext context) {
    final navigator = context.read<MNavigator>();

    final List<Widget> stackItems = List.generate(
        navigator.state.branches.length,
        (index) => _buildBranch(index, navigator));

    return Scaffold(
      body: IndexedStack(
        index: navigator.state.currentBranchIndex,
        children: stackItems,
      ),
      bottomNavigationBar: const MNavigationBar(),
    );
  }

  Widget _buildBranch(int index, MNavigator navigator) {
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
            onPopPage: (Route<dynamic> route, dynamic result) {
              if (!route.didPop(result)) {
                return false;
              }

              if (route.popDisposition == RoutePopDisposition.pop) {
                if (!navigator.state.currentBranch.atRootPage) {
                  return navigator.popPageFromCurrentBranch();
                } else {
                  return false;
                }
              }
              return false;
            },
          ),
        ),
      ),
    );
  }
}
