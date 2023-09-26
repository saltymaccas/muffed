import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/content_view/post_item/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import 'post_view_modes/post_view_modes.dart';

/// The forms posts can be displayed in
enum PostViewMode { card }

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewMode]
class PostItem extends StatelessWidget {
  ///
  const PostItem({
    required this.post,
    this.type = PostViewMode.card,
    this.openOnTap = true,
    this.limitHeight = false,
    this.useBlocFromContext,
    super.key,
  });

  final LemmyPost post;
  final PostViewMode type;
  final bool openOnTap;
  final bool limitHeight;

  /// If the item should use a already existing bloc instead of creating a new
  /// one, If it should than put the context of the bloc in
  final BuildContext? useBlocFromContext;

  @override
  Widget build(BuildContext context) {
    final postWidget = BlocBuilder<PostItemBloc, PostItemState>(
      builder: (context, state) {
        switch (type) {
          case PostViewMode.card:
            return CardLemmyPostItem(
              state.post,
              openOnTap: openOnTap,
              limitContentHeight: limitHeight,
            );
        }
      },
    );

    if (useBlocFromContext != null) {
      return BlocProvider.value(
        value: BlocProvider.of<PostItemBloc>(useBlocFromContext!),
        child: postWidget,
      );
    } else {
      return BlocProvider(
        create: (context) =>
            PostItemBloc(post: post, repo: context.read<ServerRepo>()),
        child: postWidget,
      );
    }
  }
}
