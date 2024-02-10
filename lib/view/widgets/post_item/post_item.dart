import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/error.dart';
import 'package:muffed/view/widgets/post_item/bloc/bloc.dart';
import 'package:muffed/view/widgets/post_item/post_view_modes/post_view_modes.dart';
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
class PostItem extends StatelessWidget {
  PostItem({
    this.post,
    this.postId,
    this.form = PostViewForm.card,
    this.bloc,
    this.displayType = PostDisplayType.list,
  }) : super(key: ValueKey(post));

  final int? postId;
  final LemmyPost? post;
  final PostViewForm form;
  final PostDisplayType displayType;
  final PostItemBloc? bloc;

  @override
  Widget build(BuildContext context) {
    /// The actual post widget
    final postWidget = BlocBuilder<PostItemBloc, PostItemState>(
      builder: (context, state) {
        switch (state.status) {
          case PostItemStatus.initial:
            return Skeletonizer(
              ignoreContainers: false,
              justifyMultiLineText: false,
              child: CardLemmyPostItem(
                state.post ?? placeholderPost,
                displayType: displayType,
              ),
            );

          case PostItemStatus.loading:
            return Skeletonizer(
              ignoreContainers: false,
              justifyMultiLineText: false,
              child: CardLemmyPostItem(
                placeholderPost,
                displayType: displayType,
              ),
            );
          case PostItemStatus.success:
            switch (form) {
              case PostViewForm.card:
                return CardLemmyPostItem(
                  state.post!,
                  displayType: displayType,
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

    /// Wraps with bloc
    if (bloc != null) {
      return BlocProvider.value(
        value: bloc!,
        child: postWidget,
      );
    } else {
      return BlocProvider(
        create: (context) => PostItemBloc(
          post: post,
          postId: postId,
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
  communityIcon: null,
);
