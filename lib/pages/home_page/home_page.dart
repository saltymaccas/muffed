import 'package:flutter/material.dart';
import 'package:muffed/pages/home_page/HomePageView/home_page_view.dart';
import 'package:muffed/repo/lemmy/models.dart';

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
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              floating: true,
              flexibleSpace: SafeArea(
                child: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  tabs: [Text('Home'), Text('Popular')],
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
            mode: HomePageViewMode(listingType: LemmyListingType.subscribed),
          ),
          HomePageView(
            mode: HomePageViewMode(listingType: LemmyListingType.all),
          )
        ],
      ),
    );
  }
}
