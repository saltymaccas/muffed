import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/content_view/content_view.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/screens/search/search_dialog.dart';

import 'bloc/bloc.dart';

/// The main page the user uses the scroll through content
class HomePage extends StatefulWidget {
  ///
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(repo: context.read<ServerRepo>())
        ..add(LoadInitialPostsRequested()),
      child: BlocListener<GlobalBloc, GlobalState>(
        listenWhen: (previous, current) {
          // checks whether the account has changed

          late LemmyAccountData? previousAccount;

          if (previous.lemmySelectedAccount == -1) {
            previousAccount = null;
          } else {
            previousAccount =
                previous.lemmyAccounts[previous.lemmySelectedAccount];
          }

          late LemmyAccountData? currentAccount;

          if (current.lemmySelectedAccount == -1) {
            currentAccount = null;
          } else {
            currentAccount =
                current.lemmyAccounts[current.lemmySelectedAccount];
          }

          if (previousAccount != currentAccount) {
            return true;
          }

          return false;
        },
        listener: (context, state) {
          context.read<HomePageBloc>().add(AccountChanged());
        },
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            final BuildContext blocContext = context;
            return SetPageInfo(
              indexOfRelevantItem: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    openSearchDialog(context);
                  },
                  icon: const Icon(Icons.search_rounded),
                  visualDensity: VisualDensity.compact,
                ),
                BlocProvider.value(
                  value: BlocProvider.of<HomePageBloc>(blocContext),
                  child: BlocBuilder<HomePageBloc, HomePageState>(
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
                            onTap: () => context.read<HomePageBloc>().add(
                                  SortTypeChanged(LemmySortType.hot),
                                ),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Active',
                            icon: Icon(Icons.rocket_launch),
                            value: LemmySortType.active,
                            onTap: () => context.read<HomePageBloc>().add(
                                  SortTypeChanged(LemmySortType.active),
                                ),
                          ),
                          MuffedPopupMenuItem(
                            title: 'New',
                            icon: Icon(Icons.auto_awesome),
                            value: LemmySortType.latest,
                            onTap: () => context.read<HomePageBloc>().add(
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
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topAll,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Year',
                                icon: Icon(Icons.calendar_today),
                                value: LemmySortType.topYear,
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topYear,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Month',
                                icon: Icon(Icons.calendar_month),
                                value: LemmySortType.topMonth,
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topMonth,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Week',
                                icon: Icon(Icons.view_week),
                                value: LemmySortType.topWeek,
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topWeek,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Day',
                                icon: Icon(Icons.view_day),
                                value: LemmySortType.topDay,
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topDay,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Twelve Hours',
                                icon: Icon(Icons.schedule),
                                value: LemmySortType.topTwelveHour,
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topTwelveHour,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Six Hours',
                                icon: Icon(Icons.view_module_outlined),
                                value: LemmySortType.topSixHour,
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.topSixHour,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Hour',
                                icon: Icon(Icons.hourglass_bottom),
                                value: LemmySortType.topHour,
                                onTap: () => context.read<HomePageBloc>().add(
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
                                onTap: () => context.read<HomePageBloc>().add(
                                      SortTypeChanged(
                                        LemmySortType.mostComments,
                                      ),
                                    ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'New Comments',
                                icon: Icon(Icons.add_comment),
                                value: LemmySortType.newComments,
                                onTap: () => context.read<HomePageBloc>().add(
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
                BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (context, state) {
                    if (state.lemmySelectedAccount != -1) {
                      return BlocProvider.value(
                        value: BlocProvider.of<HomePageBloc>(blocContext),
                        child: BlocBuilder<HomePageBloc, HomePageState>(
                          builder: (context, state) {
                            return MuffedPopupMenuButton(
                              icon: const Icon(Icons.filter_list),
                              visualDensity: VisualDensity.compact,
                              selectedValue: state.listingType,
                              items: [
                                MuffedPopupMenuItem(
                                  title: 'All',
                                  value: LemmyListingType.all,
                                  onTap: () => context.read<HomePageBloc>().add(
                                        ListingTypeChanged(
                                          LemmyListingType.all,
                                        ),
                                      ),
                                ),
                                MuffedPopupMenuItem(
                                  title: 'Subscribed',
                                  value: LemmyListingType.subscribed,
                                  onTap: () => context.read<HomePageBloc>().add(
                                        ListingTypeChanged(
                                          LemmyListingType.subscribed,
                                        ),
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
              child: Builder(
                builder: (BuildContext context) {
                  if (state.status == HomePageStatus.loading) {
                    return const _HomePageLoading();
                  } else if (state.status == HomePageStatus.failure) {
                    return _HomePageFailure(state.errorMessage ?? '');
                  } else if (state.status == HomePageStatus.success) {
                    return const _HomePageSuccess();
                  } else {
                    return const _HomePageInitial();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomePageInitial extends StatelessWidget {
  const _HomePageInitial();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _HomePageFailure extends StatelessWidget {
  const _HomePageFailure(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return ErrorComponentTransparent(
      message: errorMessage,
      retryFunction: () {
        context.read<HomePageBloc>().add(LoadInitialPostsRequested());
      },
    );
  }
}

class _HomePageLoading extends StatelessWidget {
  const _HomePageLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoadingComponentTransparent(),
    );
  }
}

class _HomePageSuccess extends StatelessWidget {
  const _HomePageSuccess();

  @override
  Widget build(BuildContext context) {
    final HomePageState state = context.read<HomePageBloc>().state;

    final scrollController = ScrollController();

    return BlocConsumer<HomePageBloc, HomePageState>(
      listenWhen: (previous, current) {
        // jumps to top when sort type gets changed and loaded
        if (previous.loadedSortType != current.loadedSortType) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        scrollController.jumpTo(0);
      },
      builder: (context, state) {
        return Stack(
          children: [
            ContentView(
              leadingSlivers: [
                SliverPersistentHeader(
                  delegate: _TopBarDelegate(),
                  floating: false,
                ),
              ],
              scrollController: scrollController,
              reachedNearEnd: () {
                context.read<HomePageBloc>().add(ReachedNearEndOfScroll());
              },
              onRefresh: () async {
                context.read<HomePageBloc>().add(PullDownRefresh());
                await context.read<HomePageBloc>().stream.firstWhere((element) {
                  if (element.isRefreshing == false) {
                    return true;
                  }
                  return false;
                });
              },
              posts: context.read<HomePageBloc>().state.posts!,
            ),
            if (state.isLoading)
              const SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 5,
                    child: LinearProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// right now the header is only used to create a buffer between the very
// top post and the top of the scroll view to make it easier to see

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 200;

  @override
  double get maxExtent => 200;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: const Padding(
        padding: EdgeInsets.all(8),
      ),
    );
  }

  @override
  bool shouldRebuild(_TopBarDelegate oldDelegate) => false;
}
