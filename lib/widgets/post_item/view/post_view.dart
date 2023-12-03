import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/post_item/post_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostView extends StatefulWidget {
  PostView({
    this.post,
    this.postId,
    this.bloc,
    PostViewForm? form,
    PostDisplayType? displayType,
  })  : skeletonize = false,
        form = form ?? PostViewForm.card,
        displayType = displayType ?? PostDisplayType.list,
        super(key: ValueKey(post));

  /// Shows a skeleton post, used as placeholder when posts are loading
  const PostView.skeleton({
    this.form = PostViewForm.card,
    this.displayType = PostDisplayType.list,
    super.key,
  })  : skeletonize = true,
        postId = null,
        post = null,
        bloc = null;

  final bool skeletonize;
  final int? postId;
  final LemmyPost? post;
  final PostViewForm form;
  final PostDisplayType displayType;
  final PostItemBloc? bloc;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// returns skeleton version of post is [skeletonize] is true
    if (widget.skeletonize) {
      return Skeletonizer(
        ignoreContainers: false,
        justifyMultiLineText: false,
        child: CardLemmyPostItem(
          placeholderPost,
          displayType: widget.displayType,
        ),
      );
    }

    /// The actual post widget
    return BlocBuilder<PostItemBloc, PostItemState>(
      builder: (context, state) {
        switch (state.status) {
          case PostItemStatus.initial:
            return const SizedBox();
          case PostItemStatus.loading:
            return Skeletonizer(
              ignoreContainers: false,
              justifyMultiLineText: false,
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
  }

  @override
  bool get wantKeepAlive => true;
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
