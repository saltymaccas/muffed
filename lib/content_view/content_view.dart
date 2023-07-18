import 'package:flutter/material.dart';
import 'package:muffed/content_view/post_view/card.dart';

import '../repo/lemmy/models.dart';

class ContentView extends StatelessWidget {
  const ContentView(
      {required this.onPressedPost, required this.posts, this.floatingHeader = false, this.headerDelegate, required this.reachedEnd, super.key,});

  final Function() reachedEnd;
  final Function(LemmyPost post) onPressedPost;
  final SliverPersistentHeaderDelegate? headerDelegate;
  final bool floatingHeader;
  final List posts;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels ==
            scrollInfo.metrics.maxScrollExtent) {
          reachedEnd();
        }
        return true;
      },
      child: CustomScrollView(
        cacheExtent: 99999999,
        slivers: [
          if (headerDelegate != null)SliverPersistentHeader(
              floating: floatingHeader, delegate: headerDelegate!),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: posts.length,
                      (context, index) {
                    return CardLemmyPostItem(
                        posts[index]
                        as LemmyPost, openContent: (post) {
                      onPressedPost(post);
                    });
                  }))
        ],
      ),
    );
  }
}
