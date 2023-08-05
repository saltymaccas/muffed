import 'package:flutter/material.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/content_view/post_view/card.dart';
import 'package:muffed/repo/lemmy/models.dart';

/// Displays the posts in a scroll view.
class ContentView extends StatelessWidget {
  /// initialize
  ContentView({
    required this.onPressedPost,
    required this.posts,
    required this.reachedNearEnd,
    required this.onRefresh,
    required this.scrollController,
    this.isContentLoading = false,
    this.floatingHeader = false,
    this.headerDelegate,
    this.pinnedHeader = false,
    super.key,
  });

  /// When the user has reached near the end of the scroll. often used to
  /// load more posts.
  final void Function() reachedNearEnd;

  /// When the user presses a post.
  final void Function(LemmyPost post) onPressedPost;

  /// The header delegate of the scroll view.
  final SliverPersistentHeaderDelegate? headerDelegate;

  /// Whether the header should float, meaning become visible again when
  /// the user scrolls up in any part of the scrollview.
  final bool floatingHeader;

  /// Whether the header should be pinned, meaning have the header always
  /// visible on the scroll view.
  final bool pinnedHeader;

  /// The posts that should be displayed.
  final List<LemmyPost> posts;

  /// Whether there is some content being loaded.
  final bool isContentLoading;

  /// when user pulls down to refresh
  final Future<void> Function() onRefresh;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 5000) {
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
            if (headerDelegate != null)
              SliverPersistentHeader(
                floating: floatingHeader,
                delegate: headerDelegate!,
                pinned: pinnedHeader,
              ),
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
                      return CardLemmyPostItem(
                        // key needs to be set to properly update the items
                        key: ValueKey(posts[index].apId),
                        posts[index] as LemmyPost,
                        openContent: (post) {
                          onPressedPost(post);
                        },
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }
}
