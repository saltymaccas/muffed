import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/search/search.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/comment_item/comment_item.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:muffed/widgets/post/post_widget.dart';
import 'package:muffed/widgets/snackbars.dart';

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
            repo: context.read<ServerRepo>(),
            initialState: initialState,
          )..add(SearchQueryChanged(searchQuery: searchQuery!));
        } else {
          return SearchBloc(
            repo: context.read<ServerRepo>(),
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
  /// Creates a [SearchPage]
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    /// Focuses on the search bar then unfocuses to make sure the back button
    /// removes the keyboard instead on popping the page
    final textFocusNode = FocusNode();
    final textController = TextEditingController(
      text: context.read<SearchBloc>().state.searchQuery,
    );

    final communitiesScrollController = ScrollController();
    final personsScrollController = ScrollController();
    final postsScrollController = ScrollController();
    final commentsScrollController = ScrollController();

    return BlocConsumer<SearchBloc, SearchState>(
      listenWhen: (previous, current) {
        if (previous.error != current.error && current.error != null) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        showErrorSnackBar(context, error: state.error);
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: DefaultTabController(
              length: (state.communityId != null) ? 2 : 4,
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
                      const Tab(
                        text: 'Posts',
                      ),
                      const Tab(
                        text: 'Comments',
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 500 &&
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
                              if (state.communityId == null)
                                ListView.builder(
                                  key: ValueKey(
                                    'search communities ${state.loadedSearchQuery}, ${state.loadedSortType}',
                                  ),
                                  controller: communitiesScrollController,
                                  itemCount: state.communities.length,
                                  itemBuilder: (context, index) {
                                    final theme = Theme.of(context);

                                    final community = state.communities[index];

                                    return InkWell(
                                      onTap: () {
                                        context.push(
                                          CommunityPage(
                                            community: community,
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: MuffedAvatar(
                                                    url: community.icon,
                                                    radius: 16,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        community.title,
                                                        style: theme.textTheme
                                                            .titleMedium,
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '${community.subscribers}',
                                                              style: theme
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                color: Theme.of(
                                                                  context,
                                                                )
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' members ',
                                                              style: theme
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                color: Theme.of(
                                                                  context,
                                                                )
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      if (community
                                                              .description !=
                                                          null)
                                                        Text(
                                                          community
                                                              .description!,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: theme.textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                            color: Theme.of(
                                                              context,
                                                            )
                                                                .colorScheme
                                                                .outline,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(height: 1),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              if (state.communityId == null)
                                ListView.builder(
                                  key: ValueKey(
                                    'search persons ${state.loadedSearchQuery}, ${state.loadedSortType}',
                                  ),
                                  controller: personsScrollController,
                                  itemCount: state.persons.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        // TODO: add navigation
                                      },
                                      leading: MuffedAvatar(
                                        url: state.persons[index].avatar,
                                        radius: 20,
                                      ),
                                      title: Text(state.persons[index].name),
                                      visualDensity: VisualDensity.comfortable,
                                    );
                                  },
                                ),
                              // posts
                              ListView.builder(
                                key: ValueKey(
                                  'search posts ${state.loadedSearchQuery}, ${state.loadedSortType}',
                                ),
                                controller: postsScrollController,
                                itemCount: state.posts.length,
                                itemBuilder: (context, index) {
                                  return PostWidget(post: state.posts[index]);
                                },
                              ),

                              ListView.builder(
                                key: ValueKey(
                                  'search comments ${state.loadedSearchQuery}, ${state.loadedSortType}',
                                ),
                                controller: commentsScrollController,
                                itemCount: state.comments.length,
                                itemBuilder: (context, index) {
                                  return CommentItem(
                                    displayMode: CommentItemDisplayMode.single,
                                    key: ValueKey(state.comments[index].id),
                                    comment: state.comments[index],
                                    children: const [],
                                    sortType: LemmyCommentSortType.hot,
                                  );
                                },
                              ),
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
                          TextButton(
                            onPressed: () {
                              context.read<SearchBloc>().add(SearchAll());
                            },
                            child: const Text('Search all'),
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
