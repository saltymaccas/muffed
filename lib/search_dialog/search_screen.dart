import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/comment_screen/comment_view/comment.dart';
import 'package:muffed/components/cards.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/content_view/post_view/card.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.searchQuery, this.initialState});

  final String? searchQuery;

  final SearchState? initialState;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(
      text: searchQuery,
    );

    final communitiesScrollController = ScrollController();
    final personsScrollController = ScrollController();
    final postsScrollController = ScrollController();
    final commentsScrollController = ScrollController();

    return BlocProvider(
      create: (context) {
        // if search query if not null or empty add search query changed event
        // in order to search for the search query
        if (searchQuery != null && searchQuery != '') {
          return SearchBloc(
            repo: context.read<ServerRepo>(),
            initialState: initialState,
          )
            ..add(SearchQueryChanged(searchQuery: searchQuery!));
        } else {
          return SearchBloc(
            repo: context.read<ServerRepo>(),
            initialState: initialState,
          );
        }
      },
      child: BlocConsumer<SearchBloc, SearchState>(
        listenWhen: (previous, current) {
          if (previous.loadedSortType != current.loadedSortType ||
              previous.loadedSearchQuery != current.loadedSearchQuery) {
            try {
              communitiesScrollController.jumpTo(0);
              personsScrollController.jumpTo(0);
              postsScrollController.jumpTo(0);
              commentsScrollController.jumpTo(0);
            } catch (err) {}
          }

          if (previous.errorMessage != current.errorMessage &&
              current.errorMessage != null) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          showErrorSnackBar(context, text: state.errorMessage!);
        },
        builder: (context, state) {
          /// The focus node for the search bar.
          final textFocusNode = FocusNode()
            ..requestFocus();

          final blocContext = context;

          return SetPageInfo(
            indexOfRelevantItem: 0,
            actions: [
              MuffedPopupMenuButton(
                icon: Icon(Icons.sort),
                items: [
                  BlocProvider.value(
                    value: BlocProvider.of<SearchBloc>(blocContext),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Hot',
                          isSelected: state.sortType == LemmySortType.hot,
                          onTap: () =>
                              context.read<SearchBloc>().add(
                                SortTypeChanged(
                                  LemmySortType.hot,
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<SearchBloc>(blocContext),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Active',
                          isSelected: state.sortType == LemmySortType.active,
                          onTap: () =>
                              context.read<SearchBloc>().add(
                                SortTypeChanged(
                                  LemmySortType.active,
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<SearchBloc>(blocContext),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Latest',
                          isSelected: state.sortType == LemmySortType.latest,
                          onTap: () =>
                              context.read<SearchBloc>().add(
                                SortTypeChanged(
                                  LemmySortType.latest,
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<SearchBloc>(blocContext),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return MuffedPopupMenuItem(
                          title: 'Old',
                          isSelected: state.sortType == LemmySortType.old,
                          onTap: () =>
                              context.read<SearchBloc>().add(
                                SortTypeChanged(
                                  LemmySortType.old,
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<SearchBloc>(blocContext),
                    child: BlocBuilder<SearchBloc, SearchState>(
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
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'All Time',
                                    isSelected:
                                    state.sortType == LemmySortType.topAll,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topAll,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Year',
                                    isSelected:
                                    state.sortType == LemmySortType.topYear,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topYear,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Month',
                                    isSelected: state.sortType ==
                                        LemmySortType.topMonth,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topMonth,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Week',
                                    isSelected:
                                    state.sortType == LemmySortType.topWeek,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topWeek,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Day',
                                    isSelected:
                                    state.sortType == LemmySortType.topDay,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topDay,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Twelve Hours',
                                    isSelected: state.sortType ==
                                        LemmySortType.topTwelveHour,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topTwelveHour,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Six Hours',
                                    isSelected: state.sortType ==
                                        LemmySortType.topSixHour,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topSixHour,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Hour',
                                    isSelected:
                                    state.sortType == LemmySortType.topHour,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
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
                    value: BlocProvider.of<SearchBloc>(blocContext),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return MuffedPopupMenuExpandableItem(
                          title: 'Comments',
                          isSelected:
                          state.sortType == LemmySortType.mostComments ||
                              state.sortType == LemmySortType.newComments,
                          items: [
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(blocContext),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'Most Comments',
                                    isSelected: state.sortType ==
                                        LemmySortType.mostComments,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.mostComments,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<SearchBloc>(
                                blocContext,
                              ),
                              child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  return MuffedPopupMenuItem(
                                    title: 'New Comments',
                                    isSelected: state.sortType ==
                                        LemmySortType.newComments,
                                    onTap: () =>
                                        context.read<SearchBloc>().add(
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
            child: Scaffold(
              body: SafeArea(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            text: 'Communities',
                          ),
                          Tab(
                            text: 'People',
                          ),
                          Tab(
                            text: 'Posts',
                          ),
                          Tab(
                            text: 'Comments',
                          ),
                        ],
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            NotificationListener(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent -
                                        10 &&
                                    scrollInfo.metrics.axis == Axis.vertical) {
                                  context.read<SearchBloc>().add(
                                    ReachedNearEndOfPage(),
                                  );
                                }
                                return true;
                              },
                              child: TabBarView(
                                children: [
                                  // communities
                                  ListView.builder(
                                    controller: communitiesScrollController,
                                    itemCount: state.communities.length,
                                    itemBuilder: (context, index) {
                                      return LemmyCommunityCard(
                                        community: state.communities[index],
                                      );
                                    },
                                  ),
                                  ListView.builder(
                                    controller: personsScrollController,
                                    itemCount: state.persons.length,
                                    itemBuilder: (context, index) {
                                      return LemmyPersonCard(
                                        person: state.persons[index],
                                      );
                                    },
                                  ),
                                  // posts
                                  ListView.builder(
                                    controller: postsScrollController,
                                    itemCount: state.posts.length,
                                    itemBuilder: (context, index) {
                                      return CardLemmyPostItem(
                                        state.posts[index],
                                      );
                                    },
                                  ),

                                  ListView.builder(
                                      controller: commentsScrollController,
                                      itemCount: state.comments.length,
                                      itemBuilder: (context, index) {
                                        return CommentItem(
                                            comment: state.comments[index],
                                            onReplyPressed: (_, __) {});
                                      }),
                                ],
                              ),
                            ),
                            if (state.isLoading)
                              const Align(
                                alignment: Alignment.topCenter,
                                child: LinearProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                      TextField(
                        focusNode: textFocusNode,
                        controller: textController,
                        onChanged: (query) {
                          context.read<SearchBloc>().add(
                            SearchQueryChanged(
                              searchQuery: query,
                            ),
                          );
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                          ),
                          prefixIcon: IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                if (textFocusNode.hasFocus) {
                                  textFocusNode.unfocus();
                                } else {
                                  context.pop();
                                }
                              },
                              icon: Icon(Icons.arrow_back)),
                          hintText: 'Search',
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
