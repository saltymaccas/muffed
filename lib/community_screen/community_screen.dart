import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:muffed/components/cards.dart';
import 'package:muffed/components/icon_button.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/block_dialog/block_dialog.dart';
import '../components/popup_menu/popup_menu.dart';
import 'bloc/bloc.dart';

/// The screen that displays the community including information and the
/// post view
class CommunityScreen extends StatelessWidget {
  /// initialize
  const CommunityScreen({required this.communityId, this.community, super.key});

  /// The community ID
  final int communityId;

  /// The community object which contains the community information.
  ///
  /// If this is set to null the information will be loaded from the API.
  /// Setting the value will mean the community information can be shown
  /// instantly
  final LemmyCommunity? community;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityScreenBloc(
        communityId: communityId,
        community: community,
        repo: context.read<ServerRepo>(),
      )..add(Initialize()),
      child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
        builder: (context, state) {
          final blocContext = context;

          void showAboutDialog() {
            showDialog<void>(
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: BlocProvider.of<CommunityScreenBloc>(
                    blocContext,
                  ),
                  child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                    builder: (context, state) {
                      if (state.communityInfo != null) {
                        return Dialog(
                          child: Markdown(
                            shrinkWrap: true,
                            data: state.communityInfo!.description ??
                                'no description',
                            selectable: true,
                            onTapLink: (text, url, title) {
                              launchUrl(Uri.parse(url!));
                            },
                          ),
                        );
                      } else {
                        return const Dialog(
                          child: Text('community still loading'),
                        );
                      }
                    },
                  ),
                );
                final state = context.read<CommunityScreenBloc>().state;
              },
            );
          }

          return SetPageInfo(
            actions: [
              BlocProvider.value(
                value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                  builder: (context, state) {
                    return MuffedPopupMenuButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.sort),
                      selectedValue: state.sortType,
                      items: [
                        MuffedPopupMenuItem(
                          title: 'Hot',
                          icon: Icon(Icons.local_fire_department),
                          value: LemmySortType.hot,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.hot),
                              ),
                        ),
                        MuffedPopupMenuItem(
                          title: 'Active',
                          icon: Icon(Icons.rocket_launch),
                          value: LemmySortType.active,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.active),
                              ),
                        ),
                        MuffedPopupMenuItem(
                          title: 'New',
                          icon: Icon(Icons.auto_awesome),
                          value: LemmySortType.latest,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.latest),
                              ),
                        ),
                        MuffedPopupMenuExpandableItem(
                          title: 'Top',
                          items: [
                            MuffedPopupMenuItem(
                              title: 'All Time',
                              icon: Icon(Icons.military_tech),
                              value: LemmySortType.topAll,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topAll,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Year',
                              icon: Icon(Icons.calendar_today),
                              value: LemmySortType.topYear,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topYear,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Month',
                              icon: Icon(Icons.calendar_month),
                              value: LemmySortType.topMonth,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topMonth,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Week',
                              icon: Icon(Icons.view_week),
                              value: LemmySortType.topWeek,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topWeek,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Day',
                              icon: Icon(Icons.view_day),
                              value: LemmySortType.topDay,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topDay,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Twelve Hours',
                              icon: Icon(Icons.schedule),
                              value: LemmySortType.topTwelveHour,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topTwelveHour,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Six Hours',
                              icon: Icon(Icons.view_module_outlined),
                              value: LemmySortType.topSixHour,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topSixHour,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'Hour',
                              icon: Icon(Icons.hourglass_bottom),
                              value: LemmySortType.topHour,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.topHour,
                                        ),
                                      ),
                            ),
                          ],
                        ),
                        MuffedPopupMenuExpandableItem(
                          title: 'Comments',
                          items: [
                            MuffedPopupMenuItem(
                              title: 'Most Comments',
                              icon: Icon(Icons.comment_bank),
                              value: LemmySortType.mostComments,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.mostComments,
                                        ),
                                      ),
                            ),
                            MuffedPopupMenuItem(
                              title: 'New Comments',
                              icon: Icon(Icons.add_comment),
                              value: LemmySortType.newComments,
                              onTap: () =>
                                  context.read<CommunityScreenBloc>().add(
                                        SortTypeChanged(
                                          LemmySortType.newComments,
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              BlocProvider.value(
                value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                  builder: (context, state) {
                    late Widget item;

                    if (state.communityInfoStatus == CommunityStatus.loading) {
                      item = const IconButtonLoading();
                    } else if (state.communityInfoStatus ==
                        CommunityStatus.failure) {
                      item = const IconButtonFailure();
                    } else if (state.communityInfoStatus ==
                        CommunityStatus.success) {
                      item = MuffedPopupMenuButton(
                          changeIconToSelected: false,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.more_vert),
                          items: [
                            MuffedPopupMenuItem(
                              icon: Icon(Icons.block),
                              title: 'Block/Unblock',
                              onTap: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (context) {
                                      return BlockDialog(
                                        id: state.communityInfo!.id,
                                        type: BlockDialogType.community,
                                        name: state.communityInfo!.name,
                                      );
                                    });
                              },
                            ),
                          ]);
                    } else {
                      item = IconButtonInitial();
                    }

                    return item;
                  },
                ),
              )
            ],
            indexOfRelevantItem: 0,
            // makes presses outside of the menu not register and closes the
            // menu
            child: ContentView(
              scrollController: ScrollController(),
              leadingSlivers: [
                if (state.communityInfoStatus == CommunityStatus.success)
                  SliverPersistentHeader(
                    delegate: _TopBarDelegate(community: state.communityInfo!),
                    floating: false,
                    pinned: false,
                  ),
              ],
              onRefresh: () async {},
              isContentLoading: state.postsStatus == CommunityStatus.loading,
              posts: state.posts,
              reachedNearEnd: () {
                context.read<CommunityScreenBloc>().add(ReachedEndOfScroll());
              },
            ),
          );
        },
      ),
    );
  }
}

//  TODO: make a better header

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  final LemmyCommunity community;

  _TopBarDelegate({required this.community});

  @override
  double get maxExtent => 300;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;

    return SafeArea(
      child: LemmyCommunityCard(community: community),
    );
  }
}
