import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';
import 'post_view_modes/post_view_modes.dart';

/// The forms posts can be displayed in
enum PostViewMode { card }

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewMode]
class PostItem extends StatefulWidget {
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
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final postWidget = BlocBuilder<PostItemBloc, PostItemState>(
      builder: (context, state) {
        switch (widget.type) {
          case PostViewMode.card:
            return CardLemmyPostItem(
              state.post,
              openOnTap: widget.openOnTap,
              limitContentHeight: widget.limitHeight,
            );
        }
      },
    );

    if (widget.useBlocFromContext != null) {
      return BlocProvider.value(
        value: BlocProvider.of<PostItemBloc>(widget.useBlocFromContext!),
        child: postWidget,
      );
    } else {
      return BlocProvider(
        create: (context) =>
            PostItemBloc(post: widget.post, repo: context.read<ServerRepo>()),
        child: postWidget,
      );
    }
  }
}
