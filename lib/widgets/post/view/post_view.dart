import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/post/post_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A widget that displays a post, The form the post is displayed in can be
/// changed with [PostViewForm]
class PostView extends StatefulWidget {
  const PostView({
    PostViewForm? form,
    PostDisplayType? displayType,
    super.key,
  })  : skeletonize = false,
        form = form ?? PostViewForm.card,
        displayType = displayType ?? PostDisplayType.list;

  /// Shows a skeleton post, used as placeholder when posts are loading
  const PostView.skeleton({
    this.form = PostViewForm.card,
    this.displayType = PostDisplayType.list,
    super.key,
  }) : skeletonize = true;

  final bool skeletonize;
  final PostViewForm form;
  final PostDisplayType displayType;

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
        child: PostViewCard(
          placeholderPost,
          displayType: widget.displayType,
        ),
      );
    }

    /// The actual post widget
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.initial:
            return const SizedBox();
          case PostStatus.loading:
            return;
          case PostStatus.success:
            switch (widget.form) {
              case PostViewForm.card:
                return PostViewCard(
                  state.post!,
                  displayType: widget.displayType,
                );
            }
          case PostStatus.failure:
            return ErrorComponentTransparent(
              error: state.error,
              retryFunction: () {
                context.read<PostBloc>().add(Initialize());
              },
            );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
