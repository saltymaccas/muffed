import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/search/search.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

/// A full screen page for searching for communities, posts, comments and users.
class SearchPage extends MPage<void> {
  SearchPage({
    this.searchQuery,
    this.initialState,
    this.communityId,
    this.communityName,
  }) : super(pageActions: PageActions([]));

  /// The initial search query
  final String? searchQuery;

  /// The name of the community to search in
  final String? communityName;

  /// The ID of the community to search in
  final int? communityId;

  final SearchState? initialState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // if search query if not null or empty add search query changed event
        // in order to search for the search query
        if (searchQuery != null && searchQuery != '') {
          return SearchBloc(
            initialState: initialState,
          )..add(SearchRequested(searchQuery: searchQuery!));
        } else {
          return SearchBloc(
            initialState: initialState,
            communityId: communityId,
            communityName: communityName,
          );
        }
      },
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    /// Focuses on the search bar then unfocuses to make sure the back button
    /// removes the keyboard instead on popping the page
    final textFocusNode = FocusNode();
    final textController = TextEditingController();

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      if (state.communityId == null)
                        const Tab(
                          text: 'Communities',
                        ),
                      if (state.communityId == null)
                        const Tab(
                          text: 'People',
                        ),
                      // const Tab(
                      //   text: 'Posts',
                      // ),
                      // const Tab(
                      //   text: 'Comments',
                      // ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        _CommunitySearchView(
                          key: PageStorageKey('community'),
                        ),
                        _PersonSearchView(
                          key: PageStorageKey('person'),
                        ),
                      ],
                    ),
                  ),
                  if (state.communityId != null) ...[
                    const Divider(
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Searching in ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                ),
                                TextSpan(
                                  text: state.communityName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Divider(
                    height: 1,
                  ),
                  TextField(
                    focusNode: textFocusNode,
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<SearchBloc>().add(
                                SearchRequested(
                                  searchQuery: textController.text,
                                ),
                              );
                        },
                        icon: const Icon(Icons.search),
                      ),
                      prefixIcon: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          if (textFocusNode.hasFocus) {
                            textFocusNode.unfocus();
                          } else {
                            // TODO: add navigation
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      hintText: 'Search',
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PersonSearchView extends StatelessWidget {
  const _PersonSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContentScrollBloc>(
      create: (context) => ContentScrollBloc(
        contentRetriever: PersonSearchRetriever(
          repo: context.read<ServerRepo>(),
          query: context.read<SearchBloc>().state.searchQuery,
          sortType: context.read<SearchBloc>().state.sortType,
        ),
      )..add(Initialise(loadInitialContent: false)),
      child: Builder(
        builder: (context) {
          return BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              context.read<ContentScrollBloc>().add(
                    RetrieveContentMethodChanged(
                      PersonSearchRetriever(
                        sortType: state.sortType,
                        query: state.searchQuery,
                        repo: context.read<ServerRepo>(),
                      ),
                    ),
                  );
            },
            child: const ContentScrollView(),
          );
        },
      ),
    );
  }
}

class _CommunitySearchView extends StatelessWidget {
  const _CommunitySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContentScrollBloc>(
      create: (context) => ContentScrollBloc(
        contentRetriever: CommunitySearchRetriever(
          repo: context.read<ServerRepo>(),
          query: context.read<SearchBloc>().state.searchQuery,
          sortType: context.read<SearchBloc>().state.sortType,
        ),
      )..add(Initialise(loadInitialContent: false)),
      child: Builder(
        builder: (context) {
          return BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              print('list');
              context.read<ContentScrollBloc>().add(
                    RetrieveContentMethodChanged(
                      CommunitySearchRetriever(
                        sortType: state.sortType,
                        query: state.searchQuery,
                        repo: context.read<ServerRepo>(),
                      ),
                    ),
                  );
            },
            child: const ContentScrollView(),
          );
        },
      ),
    );
  }
}
