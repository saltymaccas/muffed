import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/home_page/HomePageView/home_page_view.dart';
import 'package:muffed/repo/lemmy/models.dart';

import '../../global_state/bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) {
        if (previous.isLoggedIn() != current.isLoggedIn()) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (!state.isLoggedIn()) {
          return HomePageView(
            mode: HomePageViewMode(listingType: LemmyListingType.all),
          );
        }

        return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverToBoxAdapter(
                  child: SafeArea(
                    child: TabBar(
                      padding: const EdgeInsets.only(top: 8),
                      isScrollable: true,
                      controller: tabController,
                      tabs: const [Text('Home'), Text('Popular')],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              HomePageView(
                mode:
                    HomePageViewMode(listingType: LemmyListingType.subscribed),
              ),
              HomePageView(
                mode: HomePageViewMode(listingType: LemmyListingType.all),
              ),
            ],
          ),
        );
      },
    );
  }
}
