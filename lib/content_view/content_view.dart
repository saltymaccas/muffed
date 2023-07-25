import 'package:flutter/material.dart';
import 'package:muffed/content_view/post_view/card.dart';

import '../components/loading.dart';
import '../repo/lemmy/models.dart';

class ContentView extends StatelessWidget {
  const ContentView({
    this.isContentLoading = false,
    required this.onPressedPost,
    required this.posts,
    this.floatingHeader = false,
    this.headerDelegate,
    required this.reachedEnd,
    this.pinnedHeader = false,
    super.key,
  });

  final Function() reachedEnd;
  final Function(LemmyPost post) onPressedPost;
  final SliverPersistentHeaderDelegate? headerDelegate;
  final bool floatingHeader;
  final bool pinnedHeader;
  final List posts;
  final bool isContentLoading;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 5000) {
          reachedEnd();
        }
        return true;
      },
      child: CustomScrollView(
        cacheExtent: 999,
        slivers: [
          if (headerDelegate != null)
            SliverPersistentHeader(
                floating: floatingHeader, delegate: headerDelegate!, pinned: pinnedHeader),
          SliverList(
              delegate: (isContentLoading)
                  ? SliverChildListDelegate([
                      const SizedBox(
                        height: 300,
                        child: Center(
                          child: LoadingComponentTransparent(),
                        ),
                      )
                    ])
                  : SliverChildBuilderDelegate(childCount: posts.length,
                      (context, index) {
                      return CardLemmyPostItem(posts[index] as LemmyPost,
                          openContent: (post) {
                        onPressedPost(post);
                      });
                    }))
        ],
      ),
    );
  }
}
