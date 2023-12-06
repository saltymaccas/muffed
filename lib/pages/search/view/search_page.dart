import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/search/search.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';
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
      create: (context) => SearchBloc(
        initialState: initialState,
        communityId: communityId,
        communityName: communityName,
        searchQuery: searchQuery,
      ),
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
    final textController = TextEditingController(
      text: context.read<SearchBloc>().state.searchQuery,
    );
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final tabs = [
          const Tab(
            text: 'Posts',
          ),
          if (state.communityId == null)
            const Tab(
              text: 'Communities',
            ),
          const Tab(
            text: 'Comments',
          ),
          if (state.communityId == null)
            const Tab(
              text: 'People',
            ),
        ];

        final tabViews = [
          // keys added to kill scroll views when search changes
          // to make them only search the new query when to user
          // switches to its page
          _PostSearchView(
            key: ValueKey(['post', state]),
          ),
          if (state.communityId == null)
            _CommunitySearchView(
              key: ValueKey(['community', state]),
            ),
          _CommentSearchView(
            key: ValueKey(['comment', state]),
          ),
          if (state.communityId == null)
            _PersonSearchView(
              key: ValueKey(['person', state]),
            ),
        ];

        return Scaffold(
          backgroundColor: context.colorScheme.background,
          body: SafeArea(
            child: DefaultTabController(
              length: tabs.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: tabs,
                  ),
                  // const Divider(
                  //   height: 1,
                  // ),
                  Expanded(
                    child: TabBarView(
                      children: tabViews,
                    ),
                  ),

                  Material(
                    child: TextField(
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
                            textFocusNode.unfocus();
                          },
                          icon: const Icon(Icons.search),
                        ),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                if (textFocusNode.hasFocus) {
                                  textFocusNode.unfocus();
                                } else {
                                  context.pop();
                                }
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            if (state.communityName != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Chip(
                                  label: Text('c/${state.communityName}'),
                                  visualDensity: VisualDensity.compact,
                                  onDeleted: () {
                                    context.read<SearchBloc>().add(
                                          SearchAllRequested(),
                                        );
                                  },
                                  backgroundColor:
                                      context.colorScheme.surfaceVariant,
                                  side: BorderSide.none,
                                  padding: EdgeInsets.only(left: 6),
                                  labelPadding: EdgeInsets.zero,
                                ),
                              ),
                          ],
                        ),
                        hintText: 'Search',
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (query) {
                        context.read<SearchBloc>().add(
                              SearchRequested(
                                searchQuery: query,
                              ),
                            );
                      },
                      onTapOutside: (_) {
                        textFocusNode.unfocus();
                      },
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

class _PersonSearchView extends StatefulWidget {
  const _PersonSearchView({super.key});

  @override
  State<_PersonSearchView> createState() => _PersonSearchViewState();
}

class _PersonSearchViewState extends State<_PersonSearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<ContentScrollBloc>(
      create: (context) => ContentScrollBloc(
        contentRetriever: PersonSearchRetriever(
          repo: context.read<ServerRepo>(),
          query: context.read<SearchBloc>().state.searchQuery,
          sortType: context.read<SearchBloc>().state.sortType,
        ),
      )..add(Initialise(
          loadInitialContent:
              context.read<SearchBloc>().state.searchQuery.isNotEmpty,
        )),
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
                      persistContent: false,
                    ),
                  );
            },
            child: const ContentScrollView(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CommunitySearchView extends StatefulWidget {
  const _CommunitySearchView({super.key});

  @override
  State<_CommunitySearchView> createState() => _CommunitySearchViewState();
}

class _CommunitySearchViewState extends State<_CommunitySearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<ContentScrollBloc>(
      create: (context) => ContentScrollBloc(
        contentRetriever: CommunitySearchRetriever(
          repo: context.read<ServerRepo>(),
          query: context.read<SearchBloc>().state.searchQuery,
          sortType: context.read<SearchBloc>().state.sortType,
        ),
      )..add(
          Initialise(
            loadInitialContent:
                context.read<SearchBloc>().state.searchQuery.isNotEmpty,
          ),
        ),
      child: Builder(
        builder: (context) {
          return BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              context.read<ContentScrollBloc>().add(
                    RetrieveContentMethodChanged(
                      CommunitySearchRetriever(
                        sortType: state.sortType,
                        query: state.searchQuery,
                        repo: context.read<ServerRepo>(),
                      ),
                      persistContent: false,
                    ),
                  );
            },
            child: const ContentScrollView(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PostSearchView extends StatefulWidget {
  const _PostSearchView({super.key});

  @override
  State<_PostSearchView> createState() => _PostSearchViewState();
}

class _PostSearchViewState extends State<_PostSearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<ContentScrollBloc>(
      create: (context) => ContentScrollBloc(
        contentRetriever: PostSearchRetriever(
          repo: context.read<ServerRepo>(),
          query: context.read<SearchBloc>().state.searchQuery,
          sortType: context.read<SearchBloc>().state.sortType,
          communityId: context.read<SearchBloc>().state.communityId,
        ),
      )..add(
          Initialise(
            loadInitialContent:
                context.read<SearchBloc>().state.searchQuery.isNotEmpty,
          ),
        ),
      child: Builder(
        builder: (context) {
          return BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              context.read<ContentScrollBloc>().add(
                    RetrieveContentMethodChanged(
                      PostSearchRetriever(
                        sortType: state.sortType,
                        query: state.searchQuery,
                        repo: context.read<ServerRepo>(),
                      ),
                      persistContent: false,
                    ),
                  );
            },
            child: const ContentScrollView(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CommentSearchView extends StatefulWidget {
  const _CommentSearchView({super.key});

  @override
  State<_CommentSearchView> createState() => _CommentSearchViewState();
}

class _CommentSearchViewState extends State<_CommentSearchView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<ContentScrollBloc>(
      create: (context) => ContentScrollBloc(
        contentRetriever: CommentSearchRetriever(
          repo: context.read<ServerRepo>(),
          query: context.read<SearchBloc>().state.searchQuery,
          sortType: context.read<SearchBloc>().state.sortType,
          communityId: context.read<SearchBloc>().state.communityId,
        ),
      )..add(
          Initialise(
            loadInitialContent:
                context.read<SearchBloc>().state.searchQuery.isNotEmpty,
          ),
        ),
      child: Builder(
        builder: (context) {
          return BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              context.read<ContentScrollBloc>().add(
                    RetrieveContentMethodChanged(
                      CommentSearchRetriever(
                        sortType: state.sortType,
                        query: state.searchQuery,
                        repo: context.read<ServerRepo>(),
                      ),
                      persistContent: false,
                    ),
                  );
            },
            child: const ContentScrollView(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
