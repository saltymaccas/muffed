import 'package:flutter/material.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/repo/lemmy/models.dart';

/// Displays the posts in a scroll view.
class ContentView extends StatelessWidget {
  /// initialize
  ContentView({
    required this.onPressedPost,
    required this.posts,
    required this.reachedNearEnd,
    required this.onRefresh,
    this.leadingSlivers = const [],
    this.isContentLoading = false,
    ScrollController? scrollController,
    super.key,
  }) : scrollController = scrollController ?? ScrollController();

  /// When the user has reached near the end of the scroll. often used to
  /// load more posts.
  final void Function() reachedNearEnd;

  /// When the user presses a post.
  final void Function(LemmyPost post) onPressedPost;

  /// The posts that should be displayed.
  final List<LemmyPost> posts;

  /// Whether there is some content being loaded.
  final bool isContentLoading;

  /// when user pulls down to refresh
  final Future<void> Function() onRefresh;

  final List<Widget> leadingSlivers;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 500) {
          reachedNearEnd();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          cacheExtent: 999,
          slivers: [
            ...leadingSlivers,
            SliverList(
              delegate: isContentLoading
                  ? SliverChildListDelegate([
                      const SizedBox(
                        height: 300,
                        child: Center(
                          child: LoadingComponentTransparent(),
                        ),
                      ),
                    ])
                  : SliverChildBuilderDelegate(childCount: posts.length,
                      (context, index) {
                      return PostItem(
                        // key needs to be set to properly update the items
                        key: ValueKey(posts[index]),
                        post: posts[index],
                        openOnTap: true,
                        limitHeight: true,
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
