import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:muffed/components/post_item/bloc/bloc.dart';
import 'package:muffed/components/post_item/post_view_modes/post_view_modes.dart';

/// The forms posts can be displayed in
enum PostViewMode { card }

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewMode]
class PostItem extends StatefulWidget {
  ///
  const PostItem({
    this.post,
    this.postId,
    this.type = PostViewMode.card,
    this.openOnTap = true,
    this.limitHeight = false,
    this.useBlocFromContext,
    super.key,
  });

  final int? postId;
  final LemmyPost? post;
  final PostViewMode type;
  final bool openOnTap;
  final bool limitHeight;

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
        switch (state.status) {
          case PostItemStatus.initial:
            return const SizedBox();
          case PostItemStatus.loading:
            return Skeletonizer(
              ignoreContainers: false,
              justifyMultiLineText: false,
              ignorePointers: true,
              child: CardLemmyPostItem(
                placeholderPost,
                openOnTap: widget.openOnTap,
                limitContentHeight: widget.limitHeight,
              ),
            );
          case PostItemStatus.success:
            switch (widget.type) {
              case PostViewMode.card:
                return CardLemmyPostItem(
                  state.post!,
                  openOnTap: widget.openOnTap,
                  limitContentHeight: widget.limitHeight,
                );
            }
          case PostItemStatus.failure:
            return ErrorComponentTransparent(
              error: state.error,
              retryFunction: () {
                context.read<PostItemBloc>().add(Initialize());
              },
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
        create: (context) => PostItemBloc(
          post: widget.post,
          postId: widget.postId,
          repo: context.read<ServerRepo>(),
          globalBloc: context.read<GlobalBloc>(),
        )..add(Initialize()),
        child: postWidget,
      );
    }
  }
}

final placeholderPost = LemmyPost(
  id: 213,
  name: 'placeholder',
  body: '''
Lorem ipsum dolor sit amet. 
      Sed autem consectetur et assumenda 
      voluptas ut expedita recusandae ad excepturi incidunt ut repellendus 
      itaque. Et sunt totam qui consequatur quisquam eum aliquam placeat.''',
  creatorId: 123,
  communityId: 123,
  nsfw: false,
  thumbnailUrl: null,
  url: null,
  score: 123,
  communityName: 'placeholder',
  creatorName: 'placeholder',
  read: false,
  saved: false,
  apId: 'placeholder',
  timePublished: DateTime.now(),
  commentCount: 21,
  downVotes: 11,
  upVotes: 11,
  myVote: LemmyVoteType.none,
  communityIcon: null,
);
