import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/comment_item/comment_item.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/nothing_to_show.dart';
import 'package:muffed/repo/lemmy/models.dart';

import 'bloc/bloc.dart';

class MentionsScreen extends StatelessWidget {
  const MentionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MentionsBloc, MentionsState>(
      builder: (context, state) {
        final blocContext = context;

        return Builder(
          builder: (context) {
            if (state.replyItemsStatus == MentionsStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.replyItemsStatus == MentionsStatus.failure) {
              return ErrorComponentTransparent(
                error: state.error,
                retryFunction: () =>
                    context.read<MentionsBloc>().add(Initialize()),
              );
            } else if (state.replyItemsStatus == MentionsStatus.success) {
              late final List<LemmyInboxMention> mentionItems;

              return MuffedPage(
                isLoading: state.isLoading,
                error: state.error,
                child: (state.mentions.isEmpty ||
                        !state.showAll &&
                            state.mentions.every((element) => element.read))
                    ? NothingToShow()
                    : NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 500 &&
                              scrollInfo.metrics.axis == Axis.vertical) {
                            context
                                .read<MentionsBloc>()
                                .add(ReachedEndOfScroll());
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<MentionsBloc>().add(Refresh());
                            await context
                                .read<MentionsBloc>()
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
                            itemCount: state.mentions.length,
                            itemBuilder: (context, index) {
                              return AnimatedSize(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOutCubic,
                                child: Container(
                                  decoration: BoxDecoration(),
                                  clipBehavior: Clip.hardEdge,
                                  height: (state.mentions[index].read &&
                                          !state.showAll)
                                      ? 0
                                      : null,
                                  child: CommentItem(
                                    key: ValueKey(state.mentions[index].id),
                                    markedAsReadCallback: () {
                                      context.read<MentionsBloc>().add(
                                            MarkAsReadToggled(
                                              id: state.mentions[index].id,
                                              index: index,
                                            ),
                                          );
                                    },
                                    read: state.mentions[index].read,
                                    comment: state.mentions[index].comment,
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
