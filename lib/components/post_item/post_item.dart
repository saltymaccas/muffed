import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/post_item/bloc/bloc.dart';
import 'package:muffed/components/post_item/post_view_modes/post_view_modes.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The forms posts can be displayed in
enum PostViewForm { card }

/// The types of ways the posts can display in
///
/// [list] - Used for when the post is displayed in a list
/// [comments] - Used for when the post is displayed at the top of a comment
/// section
enum PostDisplayType { list, comments }

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostItem extends StatefulWidget {
  ///
  const PostItem({
    this.post,
    this.postId,
    this.form = PostViewForm.card,
    this.useBlocFromContext,
    this.displayType = PostDisplayType.list,
    super.key,
  }) : skeletonize = false;

  const PostItem.skeleton({
    this.form = PostViewForm.card,
    this.displayType = PostDisplayType.list,
    super.key,
  })  : skeletonize = true,
        postId = null,
        post = null,
        useBlocFromContext = null;

  final bool skeletonize;
  final int? postId;
  final LemmyPost? post;
  final PostViewForm form;
  final PostDisplayType displayType;
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
    if (widget.skeletonize) {
      return Skeletonizer(
        ignoreContainers: false,
        justifyMultiLineText: false,
        ignorePointers: true,
        child: CardLemmyPostItem(
          placeholderPost,
          displayType: widget.displayType,
        ),
      );
    }
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
                displayType: widget.displayType,
              ),
            );
          case PostItemStatus.success:
            switch (widget.form) {
              case PostViewForm.card:
                return CardLemmyPostItem(
                  state.post!,
                  displayType: widget.displayType,
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
