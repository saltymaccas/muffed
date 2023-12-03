import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/comments.dart';
import 'package:muffed/widgets/comment_item/comment_item.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/loading.dart';
import 'package:muffed/widgets/post_item/post_item.dart';
import 'package:muffed/widgets/snackbars.dart';

import 'bloc/bloc.dart';

/// Displays a screen that shows the post on top and the comments under
class PostScreen extends StatelessWidget {
  /// Displays a screen that shows the post on top and the comments under
  const PostScreen({
    this.post,
    this.postId,
    this.postBloc,
    super.key,
  }) : assert(post != null || postId != null, 'No post provided');

  /// The post that should be shown
  final LemmyPost? post;

  final int? postId;

  /// If a post bloc already exits for the post it should be passed in here
  final PostItemBloc? postBloc;

  @override
  Widget build(BuildContext context) {
    final postId = this.postId ?? post!.id;

    return Scaffold(
      body: BlocProvider(
        create: (context) => PostScreenBloc(
          repo: context.read<ServerRepo>(),
          postId: postId,
        )..add(InitializeEvent()),
        child: BlocConsumer<PostScreenBloc, PostScreenState>(
          listener: (context, state) {
            if (state.error != null) {
              showErrorSnackBar(context, error: state.error);
            }
          },
          builder: (context, state) {
            final BuildContext blocContext = context;

            return NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent &&
                    state.isLoading == false) {
                  context.read<PostScreenBloc>().add(ReachedNearEndOfScroll());
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<PostScreenBloc>().add(PullDownRefresh());
                  await context
                      .read<PostScreenBloc>()
                      .stream
                      .firstWhere((element) {
                    if (element.isRefreshing == false) {
                      return true;
                    }
                    return false;
                  });
                },
                child: CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      title: Text('Comments'),
                      floating: true,
                    ),
                    SliverToBoxAdapter(
                      child: PostWidget(
                        postId: postId,
                        post: post,
                        bloc: postBloc,
                        displayType: PostDisplayType.comments,
                      ),
                    ),
                    if (state.status == PostScreenStatus.success)
                      _CommentScreenSuccess(
                        comments: state.comments!,
                        sortType: state.sortType,
                      )
                    else if (state.status == PostScreenStatus.loading)
                      const _CommentScreenLoading()
                    else if (state.status == PostScreenStatus.failure)
                      _CommentScreenFailure(
                        error: state.error,
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: (state.isLoading)
                              ? const CircularProgressIndicator()
                              : (state.reachedEnd)
                                  ? Text('Reached End')
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CommentScreenSuccess extends StatelessWidget {
  const _CommentScreenSuccess({
    required this.comments,
    required this.sortType,
  });

  final List<LemmyComment> comments;
  final LemmyCommentSortType sortType;

  @override
  Widget build(BuildContext context) {
    final organisedComments = organiseCommentsWithChildren(
      0,
      comments,
    );

    return SliverList.builder(
      itemCount: organisedComments.length,
      itemBuilder: (context, index) {
        final key = organisedComments.keys.toList()[index];
        return CommentItem(
          key: ValueKey<int>(key.id),
          comment: key,
          children: organisedComments[key]!,
          sortType: sortType,
        );
      },
    );
  }
}

class _CommentScreenLoading extends StatelessWidget {
  const _CommentScreenLoading();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: LoadingComponentTransparent(),
    );
  }
}

class _CommentScreenFailure extends StatelessWidget {
  const _CommentScreenFailure({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ErrorComponentTransparent(
        error: error,
        retryFunction: () {
          context.read<PostScreenBloc>().add(InitializeEvent());
        },
      ),
    );
  }
}
