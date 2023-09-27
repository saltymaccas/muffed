import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
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

          /// Shows the dialog used to reply to the post
          void showCommentDialog() {
            showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: BlocProvider.of<CommentScreenBloc>(blocContext),
                  child: BlocBuilder<CommentScreenBloc, CommentScreenState>(
                    builder: (context, state) {
                      final controller = _CreateCommentDialogController();

                      return _CreateCommentDialog(
                        controller: controller,
                        onSubmitted: (content) {
                          controller.changeLoadingState(
                            loadingState: true,
                          );
                          context.read<CommentScreenBloc>().add(
                                UserCommented(
                                  comment: content,
                                  onSuccess: controller.onSuccess,
                                  onError: () {
                                    controller.changeLoadingState(
                                      loadingState: false,
                                    );
                                  },
                                ),
                              );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }

          /// Shows The dialog used to reply to a comment
          void showReplyDialog(int id, String parentContent) {
            final controller = _CreateCommentDialogController();

            showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: BlocProvider.of<CommentScreenBloc>(
                    blocContext,
                  ),
                  child: Builder(
                    builder: (context) {
                      return _CreateCommentDialog(
                        contentOfParent: parentContent,
                        onSubmitted: (comment) {
                          controller.changeLoadingState(
                            loadingState: true,
                          );
                          context.read<CommentScreenBloc>().add(
                                UserRepliedToComment(
                                  onSuccess: controller.onSuccess,
                                  onError: () {
                                    controller.changeLoadingState(
                                      loadingState: false,
                                    );
                                  },
                                  comment: comment,
                                  commentId: id,
                                ),
                              );
                        },
                        controller: controller,
                      );
                    },
                  ),
                );
              },
            );
          }

          return SetPageInfo(
            indexOfRelevantItem: 0,
            actions: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: showCommentDialog,
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

class _CreateCommentDialogController extends ChangeNotifier {
  bool successfullyPosted = false;
  bool isLoading = false;

  void onSuccess() {
    successfullyPosted = true;
    notifyListeners();
  }

  void changeLoadingState({required bool loadingState}) {
    isLoading = loadingState;
    notifyListeners();
  }
}

class _CreateCommentDialog extends StatefulWidget {
  const _CreateCommentDialog({
    required this.onSubmitted,
    required this.controller,
    this.contentOfParent,
  });

  final void Function(String content) onSubmitted;
  final _CreateCommentDialogController controller;

  /// If replying to another comment this will be set as the comment that the
  /// user is replying to.
  final String? contentOfParent;

  @override
  State<_CreateCommentDialog> createState() => _CreateCommentDialogState();
}

class _CreateCommentDialogState extends State<_CreateCommentDialog> {
  bool successfullyPosted = false;
  bool isLoading = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        successfullyPosted = widget.controller.successfullyPosted;
        isLoading = widget.controller.isLoading;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    if (successfullyPosted) {
      context.pop();
    }

    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.contentOfParent != null) ...[
            Flexible(
              flex: 2,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Markdown(
                  data: widget.contentOfParent!,
                  shrinkWrap: true,
                ),
              ),
            ),
            const Divider(),
          ],
          SizedBox(
            height: 5,
            child: isLoading ? const LinearProgressIndicator() : Container(),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: TextField(
                controller: controller,
                autofocus: true,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.onSubmitted(controller.text);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text(
                    'Comment',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
