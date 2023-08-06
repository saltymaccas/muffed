import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/menu_anchor.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/search_dialog/search_dialog.dart';

import '../components/popup_menu/popup_menu.dart';
import 'bloc/bloc.dart';

/// The main page the user uses the scroll through content
class HomePage extends StatefulWidget {
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

          if (previous.lemmySelectedAccount == null) {
            previousAccount = null;
          } else {
            previousAccount =
                previous.lemmyAccounts[previous.lemmySelectedAccount!];
          }

          late LemmyAccountData? currentAccount;

          if (current.lemmySelectedAccount == null) {
            currentAccount = null;
          } else {
            currentAccount =
                current.lemmyAccounts[current.lemmySelectedAccount!];
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
                  icon: Icon(Icons.search_rounded),
                  visualDensity: VisualDensity.compact,
                ),
                MuffedPopupMenuButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.sort),
                  items: [
                    BlocProvider.value(
                      value: BlocProvider.of<HomePageBloc>(blocContext),
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          return MuffedPopupMenuItem(
                            title: 'Hot',
                            isSelected: state.sortType == LemmySortType.hot,
                            onTap: () => context.read<HomePageBloc>().add(
                              SortTypeChanged(LemmySortType.hot),
                            ),
                          );
                        },
                      ),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<HomePageBloc>(blocContext),
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          return MuffedPopupMenuItem(
                            title: 'Active',
                            isSelected: state.sortType == LemmySortType.active,
                            onTap: () => context.read<HomePageBloc>().add(
                                  SortTypeChanged(LemmySortType.active),
                                ),
                          );
                        },
                      ),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<HomePageBloc>(blocContext),
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          return MuffedPopupMenuItem(
                            title: 'Latest',
                            isSelected: state.sortType == LemmySortType.latest,
                            onTap: () => context.read<HomePageBloc>().add(
                                  SortTypeChanged(LemmySortType.latest),
                                ),
                          );
                        },
                      ),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<HomePageBloc>(blocContext),
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          return MuffedPopupMenuItem(
                            title: 'Old',
                            isSelected: state.sortType == LemmySortType.old,
                            onTap: () => context.read<HomePageBloc>().add(
                                  SortTypeChanged(LemmySortType.old),
                                ),
                          );
                        },
                      ),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<HomePageBloc>(blocContext),
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          return MuffedPopupMenuExpandableItem(
                            title: 'Top',
                            isSelected: state.sortType ==
                                    LemmySortType.topAll ||
                                state.sortType == LemmySortType.topDay ||
                                state.sortType == LemmySortType.topHour ||
                                state.sortType == LemmySortType.topMonth ||
                                state.sortType == LemmySortType.topSixHour ||
                                state.sortType == LemmySortType.topTwelveHour ||
                                state.sortType == LemmySortType.topWeek ||
                                state.sortType == LemmySortType.topYear,
                            items: [
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'All Time',
                                      isSelected: state.sortType ==
                                          LemmySortType.topAll,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topAll),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Year',
                                      isSelected: state.sortType ==
                                          LemmySortType.topYear,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topYear),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Month',
                                      isSelected: state.sortType ==
                                          LemmySortType.topMonth,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topMonth),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Week',
                                      isSelected: state.sortType ==
                                          LemmySortType.topWeek,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topWeek),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Day',
                                      isSelected: state.sortType ==
                                          LemmySortType.topDay,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topDay),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Twelve Hours',
                                      isSelected: state.sortType ==
                                          LemmySortType.topTwelveHour,
                                      onTap: () => context
                                          .read<HomePageBloc>()
                                          .add(
                                            SortTypeChanged(
                                                LemmySortType.topTwelveHour),
                                          ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Six Hours',
                                      isSelected: state.sortType ==
                                          LemmySortType.topSixHour,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topSixHour),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Hour',
                                      isSelected: state.sortType ==
                                          LemmySortType.topHour,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                    LemmySortType.topHour),
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
                      value: BlocProvider.of<HomePageBloc>(blocContext),
                      child: BlocBuilder<HomePageBloc, HomePageState>(
                        builder: (context, state) {
                          return MuffedPopupMenuExpandableItem(
                            title: 'Comments',
                            isSelected:
                                state.sortType == LemmySortType.mostComments ||
                                    state.sortType == LemmySortType.newComments,
                            items: [
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'Most Comments',
                                      isSelected: state.sortType ==
                                          LemmySortType.mostComments,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
                                                SortTypeChanged(
                                                  LemmySortType.topAll,
                                                ),
                                              ),
                                    );
                                  },
                                ),
                              ),
                              BlocProvider.value(
                                value:
                                    BlocProvider.of<HomePageBloc>(blocContext),
                                child: BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return MuffedPopupMenuItem(
                                      title: 'New Comments',
                                      isSelected: state.sortType ==
                                          LemmySortType.newComments,
                                      onTap: () =>
                                          context.read<HomePageBloc>().add(
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
                BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (context, state) {
                    if (state.lemmySelectedAccount != null) {
                      return MuffedPopupMenuButton(
                        icon: Icon(Icons.filter_list),
                        items: [
                          BlocProvider.value(
                            value: BlocProvider.of<HomePageBloc>(blocContext),
                            child: BlocBuilder<HomePageBloc, HomePageState>(
                              builder: (context, state) {
                                return MuffedPopupMenuItem(
                                  title: 'All',
                                  isSelected:
                                      state.listingType == LemmyListingType.all,
                                  onTap: () => context.read<HomePageBloc>().add(
                                        ListingTypeChanged(
                                          LemmyListingType.all,
                                        ),
                                      ),
                                );
                              },
                            ),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<HomePageBloc>(blocContext),
                            child: BlocBuilder<HomePageBloc, HomePageState>(
                              builder: (context, state) {
                                return MuffedPopupMenuItem(
                                  title: 'Subscribed',
                                  isSelected: state.listingType ==
                                      LemmyListingType.subscribed,
                                  onTap: () => context.read<HomePageBloc>().add(
                                        ListingTypeChanged(
                                          LemmyListingType.subscribed,
                                        ),
                                      ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }else{
                      return SizedBox();
                    }
                  },
                ),
              ],
              child: Builder(
                builder: (BuildContext context) {
                  if (state.status == HomePageStatus.loading) {
                    return _HomePageLoading();
                  } else if (state.status == HomePageStatus.failure) {
                    return _HomePageFailure();
                  } else if (state.status == HomePageStatus.success) {
                    return _HomePageSuccess();
                  } else {
                    return _HomePageInitial();
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
  const _HomePageInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _HomePageFailure extends StatelessWidget {
  const _HomePageFailure({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _HomePageLoading extends StatelessWidget {
  const _HomePageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoadingComponentTransparent(),
    );
  }
}

class _HomePageSuccess extends StatelessWidget {
  const _HomePageSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageState state = context.read<HomePageBloc>().state;

    final scrollController = ScrollController();

    return BlocListener<HomePageBloc, HomePageState>(
      listenWhen: (previous, current) {
        if (previous.sortType != current.sortType &&
            current.isLoading == false) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        print('test');
        scrollController.jumpTo(0);
      },
      child: Stack(
        children: [
          ContentView(
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
            onPressedPost: (post) {
              context.go('/home/content', extra: post);
            },
            posts: context.read<HomePageBloc>().state.posts!,
            floatingHeader: false,
            headerDelegate: _TopBarDelegate(),
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
      ),
    );
  }
}

// right now the header is only used to create a buffer between the very
// top post and the top of the scroll view to make it easier to see

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 200.0;

  @override
  double get maxExtent => 200.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }

  @override
  bool shouldRebuild(_TopBarDelegate oldDelegate) => false;
}
