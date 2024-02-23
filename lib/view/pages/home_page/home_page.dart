import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/home_page/bloc/bloc.dart';
import 'package:muffed/view/pages/home_page/widgets/tab_bar/tab_bar.dart';
import 'package:muffed/view/pages/home_page/widgets/tab_view/controller.dart';
import 'package:muffed/view/pages/home_page/widgets/tab_view/tab_view.dart';
import 'package:muffed/view/pages/search/search_screen.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/view/widgets/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/view/widgets/popup_menu/popup_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  late List<String> tabs;
  late List<Widget> tabViews;
  late bool loggedIn;

  @override
  void initState() {
    super.initState();
    loggedIn = context.read<GlobalBloc>().isLoggedIn();
  }

  void onTabTap(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    tabs = [if (loggedIn) 'Subscribed', 'Popular', 'Local'];
    tabViews = [
      if (loggedIn)
        HomeTabView(
          key: const ValueKey('loggedIn'),
          contentType: HomeContentType.subscibed,
          sortType: LemmySortType.active,
          lemmyRepo: context.read<ServerRepo>().lemmyRepo,
        ),
      HomeTabView(
        key: const ValueKey('popular'),
        contentType: HomeContentType.popular,
        sortType: LemmySortType.active,
        lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      ),
      HomeTabView(
        key: const ValueKey('local'),
        contentType: HomeContentType.local,
        sortType: LemmySortType.active,
        lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      ),
    ];

    return SetPageInfo(
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SearchScreen(),
              ),
            );
          },
          icon: const Icon(Icons.search),
          visualDensity: VisualDensity.compact,
        ),
      ],
      page: Pages.home,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverSafeArea(
                sliver: SliverPersistentHeader(
                  delegate: SliverTabBarDelegate(
                    tabs: tabs,
                    selectedTab: currentTab,
                    tabTapCallback: onTabTap,
                  ),
                ),
              ),
            ];
          },
          body: tabViews[currentTab],
        ),
      ),
    );
  }
}
