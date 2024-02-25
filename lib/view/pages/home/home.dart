import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/home/widgets/tab_bar/tab_bar.dart';
import 'package:muffed/view/pages/home/widgets/tab_view/controller.dart';
import 'package:muffed/view/pages/home/widgets/tab_view/tab_view.dart';
import 'package:muffed/view/pages/search/search_screen.dart';

class TabViewConfig {
  TabViewConfig({
    required this.contentType,
    required this.key,
    required this.sortType,
  });

  final HomeContentType contentType;
  final Key key;
  final LemmySortType sortType;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController scrollController;

  int currentTab = 0;

  late List<String> tabs;
  late List<TabViewConfig> tabViews;
  late bool loggedIn;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    loggedIn = context.read<GlobalBloc>().isLoggedIn();
    tabs = [if (loggedIn) 'Subscribed', 'Global', 'Local'];
    tabViews = [
      if (loggedIn)
        TabViewConfig(
          key: const ValueKey('subscribed'),
          sortType: LemmySortType.hot,
          contentType: HomeContentType.subscibed,
        ),
      TabViewConfig(
        key: const ValueKey('popular'),
        sortType: LemmySortType.active,
        contentType: HomeContentType.popular,
      ),
      TabViewConfig(
        contentType: HomeContentType.local,
        key: const ValueKey('subscibed'),
        sortType: LemmySortType.active,
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
          lemmyRepo: context.read<ServerRepo>().lemmyRepo,
        ),
      ),
    );
  }
}
