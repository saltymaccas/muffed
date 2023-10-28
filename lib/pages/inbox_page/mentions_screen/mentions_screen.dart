import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/comment_item/comment_item.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/nothing_to_show.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/lemmy/models.dart';

import 'bloc/bloc.dart';

class MentionsScreen extends StatelessWidget {
  const MentionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MentionsBloc, MentionsState>(
      builder: (context, state) {
        final blocContext = context;

        return SetPageInfo(
          actions: [
            MuffedPopupMenuButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.more_vert),
              items: [
                BlocProvider.value(
                  value: BlocProvider.of<MentionsBloc>(blocContext),
                  child: BlocBuilder<MentionsBloc, MentionsState>(
                    builder: (context, state) {
                      return MuffedPopupMenuItem(
                        title: (state.showAll) ? 'Hide read' : 'Show read',
                        onTap: () {
                          context.read<MentionsBloc>().add(ShowAllToggled());
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
          indexOfRelevantItem: 1,
          child: Builder(
            builder: (context) {
              if (state.replyItemsStatus == MentionsStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.replyItemsStatus == MentionsStatus.failure) {
                return ErrorComponentTransparent(
                  message: state.error,
                  retryFunction: () =>
                      context.read<MentionsBloc>().add(Initialize()),
                );
              } else if (state.replyItemsStatus == MentionsStatus.success) {
                late final List<LemmyInboxMention> mentionItems;

                if (state.showAll) {
                  mentionItems = state.mentions;
                } else {
                  // removes the read comments
                  mentionItems =
                      state.mentions.where((element) => !element.read).toList();
                }

                return MuffedPage(
                  isLoading: state.isLoading,
                  error: state.error,
                  child: (mentionItems.isEmpty)
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
                            child: ListView(
                              children: List.generate(
                                mentionItems.length,
                                (index) => CommentItem(
                                  markedAsReadCallback: () {
                                    context.read<MentionsBloc>().add(
                                          MarkAsReadToggled(
                                            id: mentionItems[index].id,
                                            index: index,
                                          ),
                                        );
                                  },
                                  read: mentionItems[index].read,
                                  comment: mentionItems[index].comment,
                                  isOrphan: true,
                                  displayAsSingle: true,
                                  sortType: state.sortType,
                                  ableToLoadChildren: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        );
      },
    );
  }
}
