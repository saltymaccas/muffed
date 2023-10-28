import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

import '../loading.dart';
import 'bloc/bloc.dart';
import 'post_view_modes/post_view_modes.dart';

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
        if (state.status == PostItemStatus.failure) {
          return ErrorComponentTransparent(
            message: state.error,
            retryFunction: () {
              context.read<PostItemBloc>().add(Initialize());
            },
          );
        }
        if (state.status == PostItemStatus.loading) {
          return const LoadingComponentTransparent();
        }
        if (state.status == PostItemStatus.initial) {
          return const SizedBox();
        }
        if (state.status == PostItemStatus.success) {
          switch (widget.type) {
            case PostViewMode.card:
              return CardLemmyPostItem(
                state.post!,
                openOnTap: widget.openOnTap,
                limitContentHeight: widget.limitHeight,
              );
          }
        }

        return Text('Something went wrong');
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
