import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:muffed/widgets/comment_item/comment_item.dart';
import 'package:muffed/widgets/error.dart';
import 'package:muffed/widgets/nothing_to_show.dart';

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
              return const Center(child: CircularProgressIndicator());
            } else if (state.replyItemsStatus == MentionsStatus.failure) {
              return ErrorComponentTransparent(
                error: state.error,
                retryFunction: () =>
                    context.read<MentionsBloc>().add(Initialize()),
              );
            } else if (state.replyItemsStatus == MentionsStatus.success) {
              late final List<LemmyInboxMention> mentionItems;

              final nothingToShow = state.mentions.isEmpty ||
                  !state.showAll &&
                      state.mentions.every((element) => element.read);

              return NotificationListener(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 500 &&
                      scrollInfo.metrics.axis == Axis.vertical &&
                      !nothingToShow) {
                    context.read<MentionsBloc>().add(ReachedEndOfScroll());
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
                  child: nothingToShow
                      ? const Center(
                          child: SingleChildScrollView(child: NothingToShow()),
                        )
                      : ListView.builder(
                          key: ValueKey(state.showAll),
                          itemCount: state.mentions.length,
                          itemBuilder: (context, index) {
                            return AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                              child: Container(
                                decoration: const BoxDecoration(),
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
                                  displayMode: CommentItemDisplayMode.single,
                                  sortType: state.sortType,
                                  ableToLoadChildren: false,
                                ),
                              ),
                            );
                          },
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
