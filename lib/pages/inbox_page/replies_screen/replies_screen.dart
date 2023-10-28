import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/comment_item/comment_item.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/nothing_to_show.dart';
import 'package:muffed/repo/lemmy/models.dart';

import 'bloc/bloc.dart';

class RepliesScreen extends StatelessWidget {
  const RepliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepliesBloc, RepliesState>(
      builder: (context, state) {
        final blocContext = context;

        return Builder(
          builder: (context) {
            if (state.replyItemsStatus == RepliesStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.replyItemsStatus == RepliesStatus.failure) {
              return ErrorComponentTransparent(
                error: state.error,
                retryFunction: () =>
                    context.read<RepliesBloc>().add(Initialize()),
              );
            } else if (state.replyItemsStatus == RepliesStatus.success) {
              late final List<LemmyInboxMention> mentionItems;

              return MuffedPage(
                isLoading: state.isLoading,
                error: state.error,
                child: (state.replies.isEmpty ||
                        !state.showAll &&
                            state.replies.every((element) => element.read))
                    ? NothingToShow()
                    : NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 500 &&
                              scrollInfo.metrics.axis == Axis.vertical) {
                            context
                                .read<RepliesBloc>()
                                .add(ReachedEndOfScroll());
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<RepliesBloc>().add(Refresh());
                            await context
                                .read<RepliesBloc>()
                                .stream
                                .firstWhere((element) {
                              if (element.isRefreshing == false) {
                                return true;
                              }
                              return false;
                            });
                          },
                          child: ListView.builder(
                            key: ValueKey(state.showAll),
                            itemCount: state.replies.length,
                            itemBuilder: (context, index) {
                              return AnimatedSize(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOutCubic,
                                child: Container(
                                  decoration: BoxDecoration(),
                                  clipBehavior: Clip.hardEdge,
                                  height: (state.replies[index].read &&
                                          !state.showAll)
                                      ? 0
                                      : null,
                                  child: CommentItem(
                                    key: ValueKey(state.replies[index].id),
                                    markedAsReadCallback: () {
                                      context.read<RepliesBloc>().add(
                                            MarkAsReadToggled(
                                              id: state.replies[index].id,
                                              index: index,
                                            ),
                                          );
                                    },
                                    read: state.replies[index].read,
                                    comment: state.replies[index].comment,
                                    isOrphan: true,
                                    displayAsSingle: true,
                                    sortType: state.sortType,
                                    ableToLoadChildren: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
