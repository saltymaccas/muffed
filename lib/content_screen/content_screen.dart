import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/content_view/post_view/card.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';
import 'comment_view/comment.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen(this.post, {super.key});

  final LemmyPost post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentScreenBloc(
        repo: context.read<ServerRepo>(),
        postId: post.id,
      )..add(InitializeEvent()),
      child: BlocBuilder<ContentScreenBloc, ContentScreenState>(
        builder: (context, state) {
          return NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                context.read<ContentScreenBloc>().add(ReachedNearEndOfScroll());
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
                if (state.status == ContentScreenStatus.loading)
                  const SliverFillRemaining(
                    child: LoadingComponentTransparent(),
                  )
                else
                  (state.status == ContentScreenStatus.failure)
                      ? SliverFillRemaining(
                          child: ErrorComponentTransparent(
                            message: state.errorMessage ?? 'failed to load',
                          ),
                        )
                      : (state.status == ContentScreenStatus.initial)
                          ? SliverFillRemaining(
                              child: Container(),
                            )
                          : SetPageInfo(
                              indexOfRelevantItem: 0,
                              actions: [
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {},
                                    icon: Icon(Icons.add)),
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {},
                                    icon: Icon(Icons.sort))
                              ],
                              child: SliverList(
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
                            ),
              ],
            ),
          );
        },
      ),
    );
  }
}
