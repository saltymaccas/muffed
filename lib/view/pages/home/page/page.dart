import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/view/pages/home/home.dart';
import 'package:muffed/view/pages/search/search_screen.dart';
import 'package:muffed/view/router/router.dart';

class HomePage extends MPage<void> {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return const HomePageView();
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final ScrollController scrollController;

  int currentTab = 0;

  late List<String> tabs;
  late List<TabViewConfig> tabViews;
  late bool loggedIn;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    // context.read<PageActions>().setActions([
    //   IconButton(
    //     visualDensity: VisualDensity.compact,
    //     onPressed: () => MNavigator.of(context).pushPage(SearchPage()),
    //     icon: const Icon(Icons.search),
    //   ),
    // ]);

    loggedIn = context.read<LemmyKeychainBloc>().state.isAuthenticated;
    tabs = [if (loggedIn) 'Subscribed', 'Global', 'Local'];
    tabViews = [
      if (loggedIn)
        TabViewConfig(
          key: const ValueKey('subscribed'),
          sortType: SortType.hot,
          contentType: HomeContentType.subscibed,
        ),
      TabViewConfig(
        key: const ValueKey('popular'),
        sortType: SortType.active,
        contentType: HomeContentType.popular,
      ),
      TabViewConfig(
        contentType: HomeContentType.local,
        key: const ValueKey('subscibed'),
        sortType: SortType.active,
      ),
    ];
  }

  void onTabTap(int index) {
    setState(() {
      currentTab = index;
    });
  }

  void openSearchPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabViewConfig = tabViews[currentTab];

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                sliver: SliverPersistentHeader(
                  floating: true,
                  delegate: SliverTabBarDelegate(
                    tabs: tabs,
                    selectedTab: currentTab,
                    tabTapCallback: onTabTap,
                    suffix: [
                      IconButton(
                        onPressed: () => openSearchPage(context),
                        icon: const Icon(Icons.search),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: HomeTabView(
          key: tabViewConfig.key,
          contentType: tabViewConfig.contentType,
          sortType: tabViewConfig.sortType,
          lemmyRepo: context.read<LemmyRepo>(),
        ),
      ),
    );
  }
}
