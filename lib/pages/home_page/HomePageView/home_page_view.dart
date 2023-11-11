import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/home_page/HomePageView/bloc/bloc.dart';
import 'package:muffed/pages/home_page/screens/search/search_dialog.dart';
import 'package:muffed/repo/server_repo.dart';

/// Defines the posts that the view will show
class HomePageViewMode {
  HomePageViewMode({required this.listingType});

  final LemmyListingType listingType;
}

/// The main page the user uses the scroll through content
class HomePageView extends StatelessWidget {
  const HomePageView({required this.mode, super.key});

  final HomePageViewMode mode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeViewPageBloc(repo: context.read<ServerRepo>(), mode: mode)
            ..add(LoadInitialPostsRequested()),
      child: Builder(
        builder: (context) {
          BuildContext blocContext = context;

          context.read<DynamicNavigationBarBloc>().add(
                EditPageActions(
                  context: context,
                  page: Pages.home,
                  actions: [
                    IconButton(
                      onPressed: () {
                        openSearchDialog(context);
                      },
                      icon: const Icon(Icons.search_rounded),
                      visualDensity: VisualDensity.compact,
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<HomeViewPageBloc>(blocContext),
                      child: BlocBuilder<HomeViewPageBloc, HomePageViewState>(
                        builder: (context, state) {
                          return MuffedPopupMenuButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.sort),
                            selectedValue: state.sortType,
                            items: [
                              MuffedPopupMenuItem(
                                title: 'Hot',
                                icon: const Icon(Icons.local_fire_department),
                                value: LemmySortType.hot,
                                onTap: () =>
                                    context.read<HomeViewPageBloc>().add(
                                          SortTypeChanged(LemmySortType.hot),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Active',
                                icon: const Icon(Icons.rocket_launch),
                                value: LemmySortType.active,
                                onTap: () =>
                                    context.read<HomeViewPageBloc>().add(
                                          SortTypeChanged(LemmySortType.active),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'New',
                                icon: const Icon(Icons.auto_awesome),
                                value: LemmySortType.latest,
                                onTap: () =>
                                    context.read<HomeViewPageBloc>().add(
                                          SortTypeChanged(LemmySortType.latest),
                                        ),
                              ),
                              MuffedPopupMenuExpandableItem(
                                title: 'Top',
                                items: [
                                  MuffedPopupMenuItem(
                                    title: 'All Time',
                                    icon: const Icon(Icons.military_tech),
                                    value: LemmySortType.topAll,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topAll,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Year',
                                    icon: const Icon(Icons.calendar_today),
                                    value: LemmySortType.topYear,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topYear,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Month',
                                    icon: const Icon(Icons.calendar_month),
                                    value: LemmySortType.topMonth,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topMonth,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Week',
                                    icon: const Icon(Icons.view_week),
                                    value: LemmySortType.topWeek,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topWeek,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Day',
                                    icon: const Icon(Icons.view_day),
                                    value: LemmySortType.topDay,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topDay,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Twelve Hours',
                                    icon: const Icon(Icons.schedule),
                                    value: LemmySortType.topTwelveHour,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topTwelveHour,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Six Hours',
                                    icon:
                                        const Icon(Icons.view_module_outlined),
                                    value: LemmySortType.topSixHour,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.topSixHour,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'Hour',
                                    icon: const Icon(Icons.hourglass_bottom),
                                    value: LemmySortType.topHour,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
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
                                    icon: const Icon(Icons.comment_bank),
                                    value: LemmySortType.mostComments,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
                                              SortTypeChanged(
                                                LemmySortType.mostComments,
                                              ),
                                            ),
                                  ),
                                  MuffedPopupMenuItem(
                                    title: 'New Comments',
                                    icon: const Icon(Icons.add_comment),
                                    value: LemmySortType.newComments,
                                    onTap: () =>
                                        context.read<HomeViewPageBloc>().add(
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
                  ],
                ),
              );
          return BlocBuilder<HomeViewPageBloc, HomePageViewState>(
            builder: (context, state) {
              final BuildContext blocContext = context;
              return MuffedPage(
                isLoading: state.isLoading,
                error: state.error,
                child: BlocListener<GlobalBloc, GlobalState>(
                  listenWhen: (previous, current) {
                    final LemmyAccountData? previousAccount =
                        (previous.lemmySelectedAccount == -1)
                            ? null
                            : previous
                                .lemmyAccounts[previous.lemmySelectedAccount];

                    final LemmyAccountData? currentAccount =
                        (current.lemmySelectedAccount == -1)
                            ? null
                            : current
                                .lemmyAccounts[current.lemmySelectedAccount];

                    if (previousAccount != currentAccount ||
                        previous.lemmyDefaultHomeServer !=
                                current.lemmyDefaultHomeServer &&
                            current.lemmySelectedAccount == -1) {
                      return true;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    context
                        .read<HomeViewPageBloc>()
                        .add(LoadInitialPostsRequested());
                  },
                  child: Builder(
                    builder: (BuildContext context) {
                      if (state.status == HomePageStatus.loading) {
                        return const _HomePageLoading();
                      } else if (state.status == HomePageStatus.failure) {
                        return _HomePageFailure(state.error);
                      } else if (state.status == HomePageStatus.success) {
                        return _HomePageSuccess(
                          key: ValueKey(
                            '${state.loadedSortType}',
                          ),
                          isLoading: state.isLoading,
                          posts: state.posts!,
                        );
                      } else {
                        return const _HomePageInitial();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomePageSuccess extends StatelessWidget {
  const _HomePageSuccess({
    required this.posts,
    required this.isLoading,
    super.key,
  });

  final List<LemmyPost> posts;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 500 &&
            scrollInfo.depth == 0) {
          context.read<HomeViewPageBloc>().add(ReachedNearEndOfScroll());
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeViewPageBloc>().add(PullDownRefresh());
          await context.read<HomeViewPageBloc>().stream.firstWhere((element) {
            if (element.isRefreshing == false) {
              return true;
            }
            return false;
          });
        },
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              addAutomaticKeepAlives: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostItem(
                  key: ValueKey(posts[index]),
                  post: posts[index],
                  limitHeight: true,
                );
              },
            ),
          ],
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
  const _HomePageFailure(this.error);

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return ErrorComponentTransparent(
      error: error,
      retryFunction: () {
        context.read<HomeViewPageBloc>().add(LoadInitialPostsRequested());
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
