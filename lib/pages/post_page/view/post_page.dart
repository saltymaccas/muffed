import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/post_page/post_page.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/utils/comments.dart';
import 'package:muffed/widgets/comment_item/comment_item.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/loading.dart';
import 'package:muffed/widgets/post/post_widget.dart';
import 'package:muffed/widgets/snackbars.dart';

class PostPage extends MPage<void> {
  PostPage({this.post, this.postId, this.postBloc})
      : super(pageActions: PageActions([]));

  final LemmyPost? post;
  final int? postId;
  final PostBloc? postBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostPageBloc(
            repo: context.read<ServerRepo>(),
            id: postId,
            post: post,
          )..add(InitializeEvent()),
        ),
        if (postBloc != null)
          BlocProvider.value(value: postBloc!)
        else
          BlocProvider(
            create: (context) => PostBloc(
              repo: context.read<ServerRepo>(),
              globalBloc: context.read<GlobalBloc>(),
            )..add(Initialize()),
          ),
      ],
      child: const _PostView(),
    );
  }
}

/// Displays a screen that shows the post on top and the comments under
class _PostView extends StatelessWidget {
  const _PostView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PostPageBloc, PostPageState>(
        listener: (context, state) {
          if (state.error != null) {
            showErrorSnackBar(context, error: state.error);
          }
        },
        builder: (context, state) {
          return NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent &&
                  state.isLoading == false) {
                context.read<PostPageBloc>().add(ReachedNearEndOfScroll());
              }
              return true;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<PostPageBloc>().add(PullDownRefresh());
                await context.read<PostPageBloc>().stream.firstWhere((element) {
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
                      bloc: BlocProvider.of<PostBloc>(context),
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
          context.read<PostPageBloc>().add(InitializeEvent());
        },
      ),
    );
  }
}
