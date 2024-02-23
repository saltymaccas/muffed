import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/home_page/widgets/tab_view/controller.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({
    required this.contentType,
    required this.sortType,
    required this.lemmyRepo,
    super.key,
  });

  final HomeContentType contentType;

  final LemmySortType sortType;
  final LemmyRepo lemmyRepo;

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  late final HomeTabViewController controller;
  late List<LemmyPost>? items;
  LemmySortType sortType = LemmySortType.active;
  HomeContentType contentType = HomeContentType.popular;
  HomeTabViewStatus status = HomeTabViewStatus.idle;

  @override
  void initState() {
    super.initState();
    controller = HomeTabViewController(lemmyRepo: widget.lemmyRepo);
    onState(controller.state);
    sortType = widget.sortType;
    contentType = widget.contentType;
    controller.loadInitialContent(sortType: sortType, contentType: contentType);

    controller.stream.listen(onStreamEvent);
  }

  Widget itemBuilder(BuildContext context, Object item) {
    if (item is LemmyPost) {
      return PostItem(
        post: item,
      );
    } else {
      return const SizedBox(
        height: 100,
        width: 200,
        child: Center(
          child: Text('ItemType not recognised'),
        ),
      );
    }
  }

  void onStreamEvent(HomeTabViewModel state) {
    setState(() {
      onState(state);
    });
  }

  void onState(HomeTabViewModel state) {
    items = state.items;
    status = state.status;
  }

  @override
  Widget build(BuildContext context) {
    return PagedScroll(
      onRefresh: () async {
        await controller.loadInitialContent(
          sortType: sortType,
          contentType: contentType,
        );
      },
      status: {
        HomeTabViewStatus.idle: PagedScrollViewStatus.idle,
        HomeTabViewStatus.loading: PagedScrollViewStatus.loading,
        HomeTabViewStatus.failure: PagedScrollViewStatus.failure,
        HomeTabViewStatus.loadingNext: PagedScrollViewStatus.loadingMore,
        HomeTabViewStatus.loadingNextFailure:
            PagedScrollViewStatus.loadingMoreFailure,
      }[status]!,
      items: items,
      itemBuilder: itemBuilder,
      loadMoreCallback: controller.loadNextPage,
    );
  }
}
