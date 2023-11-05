import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/comment_item/comment_item.dart';
import 'package:muffed/components/create_comment/create_comment_dialog.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/comments.dart';

import 'bloc/bloc.dart';

/// Displays a screen that shows the post on top and the comments under
class PostScreen extends StatelessWidget {
  /// Displays a screen that shows the post on top and the comments under
  const PostScreen({
    this.post,
    this.postId,
    this.postItemBlocContext,
    super.key,
  });

  /// The post that should be shown
  final LemmyPost? post;

  final int? postId;

  /// If a post bloc already exits for the post it should be passed in here
  final BuildContext? postItemBlocContext;

  @override
  Widget build(BuildContext context) {
    final postId = this.postId ?? post!.id;

    return Scaffold(
      body: BlocProvider(
        create: (context) => PostScreenBloc(
          repo: context.read<ServerRepo>(),
          postId: postId,
        )..add(InitializeEvent()),
        child: BlocBuilder<PostScreenBloc, PostScreenState>(
          builder: (context, state) {
            final BuildContext blocContext = context;

            return SetPageInfo(
              indexOfRelevantItem: 0,
              actions: [
                if (context.read<GlobalBloc>().isLoggedIn())
                  MuffedPage(
                    isLoading: state.isLoading,
                    error: state.error,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        showDialog<void>(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CreateCommentDialog(
                              postBlocContext: blocContext,
                              postId: postId,
                              onSuccessfullySubmitted: () {
                                showInfoSnackBar(
                                  context,
                                  text: 'Comment successfully posted',
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                BlocProvider.value(
                  value: BlocProvider.of<PostScreenBloc>(blocContext),
                  child: BlocBuilder<PostScreenBloc, PostScreenState>(
                    builder: (context, state) {
                      return MuffedPopupMenuButton(
                        icon: Icon(Icons.sort),
                        visualDensity: VisualDensity.compact,
                        selectedValue: state.sortType,
                        items: [
                          MuffedPopupMenuItem(
                            title: 'Hot',
                            icon: Icon(Icons.local_fire_department),
                            value: LemmyCommentSortType.hot,
                            onTap: () => context
                                .read<PostScreenBloc>()
                                .add(SortTypeChanged(LemmyCommentSortType.hot)),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Top',
                            icon: Icon(Icons.military_tech),
                            value: LemmyCommentSortType.top,
                            onTap: () => context
                                .read<PostScreenBloc>()
                                .add(SortTypeChanged(LemmyCommentSortType.top)),
                          ),
                          MuffedPopupMenuItem(
                            title: 'New',
                            icon: Icon(Icons.auto_awesome),
                            value: LemmyCommentSortType.latest,
                            onTap: () => context.read<PostScreenBloc>().add(
                                  SortTypeChanged(LemmyCommentSortType.latest),
                                ),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Old',
                            icon: Icon(Icons.elderly),
                            value: LemmyCommentSortType.old,
                            onTap: () => context
                                .read<PostScreenBloc>()
                                .add(SortTypeChanged(LemmyCommentSortType.old)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              child: NotificationListener(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent &&
                      state.isLoading == false) {
                    context
                        .read<PostScreenBloc>()
                        .add(ReachedNearEndOfScroll());
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
                        child: PostItem(
                          postId: postId,
                          post: post,
                          useBlocFromContext: postItemBlocContext,
                          openOnTap: false,
                          limitHeight: false,
                          type: PostViewMode.card,
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
                    ],
                  ),
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
    super.key,
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
      addAutomaticKeepAlives: true,
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
  const _CommentScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: LoadingComponentTransparent(),
    );
  }
}

class _CommentScreenFailure extends StatelessWidget {
  const _CommentScreenFailure({this.error, super.key});

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
