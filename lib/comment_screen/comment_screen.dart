import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/create_comment/create_comment_dialog.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/comments.dart';

import '../components/comment_item/comment_item.dart';
import '../components/popup_menu/popup_menu.dart';
import 'bloc/bloc.dart';

/// Displays a screen that shows the post on top and the comments under
class CommentScreen extends StatelessWidget {
  const CommentScreen(
      {required this.post, required this.postItemBlocContext, super.key});

  // TODO: make it optional to pass post or postItemBlocContext

  /// The post that should be shown
  final LemmyPost post;
  final BuildContext postItemBlocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentScreenBloc(
        repo: context.read<ServerRepo>(),
        post: post,
      )..add(InitializeEvent()),
      child: BlocConsumer<CommentScreenBloc, CommentScreenState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            showErrorSnackBar(context, text: state.errorMessage!);
          }
        },
        builder: (context, state) {
          final BuildContext blocContext = context;

          return SetPageInfo(
            indexOfRelevantItem: 0,
            actions: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return CreateCommentDialog(postId: post.id);
                    },
                  );
                },
                icon: const Icon(Icons.add),
              ),
              BlocProvider.value(
                value: BlocProvider.of<CommentScreenBloc>(blocContext),
                child: BlocBuilder<CommentScreenBloc, CommentScreenState>(
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
                              .read<CommentScreenBloc>()
                              .add(SortTypeChanged(LemmyCommentSortType.hot)),
                        ),
                        MuffedPopupMenuItem(
                          title: 'Top',
                          icon: Icon(Icons.military_tech),
                          value: LemmyCommentSortType.top,
                          onTap: () => context
                              .read<CommentScreenBloc>()
                              .add(SortTypeChanged(LemmyCommentSortType.top)),
                        ),
                        MuffedPopupMenuItem(
                          title: 'New',
                          icon: Icon(Icons.auto_awesome),
                          value: LemmyCommentSortType.latest,
                          onTap: () => context.read<CommentScreenBloc>().add(
                                SortTypeChanged(LemmyCommentSortType.latest),
                              ),
                        ),
                        MuffedPopupMenuItem(
                          title: 'Old',
                          icon: Icon(Icons.elderly),
                          value: LemmyCommentSortType.old,
                          onTap: () => context
                              .read<CommentScreenBloc>()
                              .add(SortTypeChanged(LemmyCommentSortType.old)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            child: Stack(
              children: [
                NotificationListener(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent &&
                        state.isLoading == false) {
                      context
                          .read<CommentScreenBloc>()
                          .add(ReachedNearEndOfScroll());
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<CommentScreenBloc>().add(PullDownRefresh());
                      await context
                          .read<CommentScreenBloc>()
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
                        SliverToBoxAdapter(
                          child: PostItem(
                            post: post,
                            useBlocFromContext: postItemBlocContext,
                            openOnTap: false,
                            limitHeight: false,
                            type: PostViewMode.card,
                          ),
                        ),
                        if (state.status == CommentScreenStatus.success)
                          _CommentScreenSuccess(
                            comments: state.comments!,
                          ),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  const SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CommentScreenSuccess extends StatelessWidget {
  const _CommentScreenSuccess({required this.comments, super.key});

  final List<LemmyComment> comments;

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
          comment: key,
          children: organisedComments[key]!,
        );
      },
    );
  }
}
