import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/cards.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:url_launcher/url_launcher.dart';

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
              MuffedPopupMenuButton(
                icon: Icon(Icons.more_vert),
                visualDensity: VisualDensity.compact,
                items: [
                  MuffedPopupMenuItem(
                    title: 'About',
                    onTap: showAboutDialog,
                  ),
                ],
              ),
              MuffedPopupMenuButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.sort),
                items: [
                  BlocProvider.value(
                    value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Hot',
                          isSelected: state.sortType == LemmySortType.hot,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.hot),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Active',
                          isSelected: state.sortType == LemmySortType.active,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.active),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Latest',
                          isSelected: state.sortType == LemmySortType.latest,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.latest),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Old',
                          isSelected: state.sortType == LemmySortType.old,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.old),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return MuffedPopupMenuExpandableItem(
                          title: 'Top',
                          isSelected: state.sortType == LemmySortType.topAll ||
                              state.sortType == LemmySortType.topDay ||
                              state.sortType == LemmySortType.topHour ||
                              state.sortType == LemmySortType.topMonth ||
                              state.sortType == LemmySortType.topSixHour ||
                              state.sortType == LemmySortType.topTwelveHour ||
                              state.sortType == LemmySortType.topWeek ||
                              state.sortType == LemmySortType.topYear,
                          items: [
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'All Time',
                                    isSelected:
                                        state.sortType == LemmySortType.topAll,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topAll,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Year',
                                    isSelected:
                                        state.sortType == LemmySortType.topYear,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topYear,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Month',
                                    isSelected: state.sortType ==
                                        LemmySortType.topMonth,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topMonth,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Week',
                                    isSelected:
                                        state.sortType == LemmySortType.topWeek,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topWeek,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Day',
                                    isSelected:
                                        state.sortType == LemmySortType.topDay,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topDay,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Twelve Hours',
                                    isSelected: state.sortType ==
                                        LemmySortType.topTwelveHour,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topTwelveHour,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Six Hours',
                                    isSelected: state.sortType ==
                                        LemmySortType.topSixHour,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topSixHour,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Hour',
                                    isSelected:
                                        state.sortType == LemmySortType.topHour,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topHour,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return MuffedPopupMenuExpandableItem(
                          title: 'Comments',
                          isSelected:
                              state.sortType == LemmySortType.mostComments ||
                                  state.sortType == LemmySortType.newComments,
                          items: [
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Most Comments',
                                    isSelected: state.sortType ==
                                        LemmySortType.mostComments,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topAll,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CommunityScreenBloc>(
                                  blocContext),
                              child: BlocBuilder<CommunityScreenBloc,
                                  CommunityScreenState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'New Comments',
                                    isSelected: state.sortType ==
                                        LemmySortType.newComments,
                                    onTap: () =>
                                        context.read<CommunityScreenBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.newComments,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
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
              onPressedPost: (post) {
                context.push('/home/content', extra: post);
              },
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
