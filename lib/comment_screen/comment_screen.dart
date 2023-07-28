import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/content_view/post_view/card.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';
import 'comment_view/comment.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen(this.post, {super.key});

  final LemmyPost post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentScreenBloc(
        repo: context.read<ServerRepo>(),
        postId: post.id,
      )..add(InitializeEvent()),
      child: BlocBuilder<CommentScreenBloc, CommentScreenState>(
        builder: (context, state) {
          final BuildContext blocContext = context;

          return SetPageInfo(
            indexOfRelevantItem: 0,
            actions: [
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    showDialog<void>(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        final TextEditingController controller =
                            TextEditingController();

                        return BlocProvider.value(
                          value: BlocProvider.of<CommentScreenBloc>(blocContext),
                          child: BlocBuilder<CommentScreenBloc,
                              CommentScreenState>(
                            builder: (context, state) {
                              return Dialog(
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                      child: (state.createdCommentGettingPosted)
                                          ? LinearProgressIndicator()
                                          : Container(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 5,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              child: Text('Cancel')),
                                          SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<CommentScreenBloc>()
                                                  .add(
                                                    UserCommented(
                                                        controller.text, () {
                                                      context.pop();
                                                    }),
                                                  );
                                            },
                                            child: Text(
                                              'Comment',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (state.createCommentErrorMessage != null)
                                      ErrorComponentTransparent(
                                        message:
                                            state.createCommentErrorMessage!,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add)),
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.sort)),
            ],
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  context
                      .read<CommentScreenBloc>()
                      .add(ReachedNearEndOfScroll());
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    title: Text('Comments'),
                    floating: true,
                  ),
                  SliverToBoxAdapter(
                    child: CardLemmyPostItem(
                      post,
                      limitContentHeight: false,
                    ),
                  ),
                  if (state.status == CommentScreenStatus.loading)
                    const SliverFillRemaining(
                      child: LoadingComponentTransparent(),
                    )
                  else
                    (state.status == CommentScreenStatus.failure)
                        ? SliverFillRemaining(
                            child: ErrorComponentTransparent(
                              message: state.errorMessage ?? 'failed to load',
                            ),
                          )
                        : (state.status == CommentScreenStatus.initial)
                            ? SliverFillRemaining(
                                child: Container(),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    childCount: state.comments!.length,
                                    (context, index) {
                                  return Column(
                                    children: [
                                      CommentItem(state.comments![index]),
                                      const Divider(),
                                    ],
                                  );
                                }),
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
