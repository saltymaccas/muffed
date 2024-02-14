import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/search/controller/controller.dart';
import 'package:muffed/view/widgets/comment_item/comment_item.dart';
import 'package:muffed/view/widgets/community/community.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';

/// A Screen for search communities comments posts and users
class SearchScreen extends StatefulWidget {
  /// Creates a [SearchScreen]
  const SearchScreen({
    super.key,
    this.searchQuery,
    this.communityId,
    this.communityName,
  });

  final String? searchQuery;

  final String? communityName;
  final int? communityId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final textFocusNode = FocusNode();
  late final TextEditingController textController;

  late final SearchCubit communityCubit;
  late final SearchCubit usersCubit;
  late final SearchCubit commentsCubit;
  late final SearchCubit postsCubit;

  late final TabController tabController;

  LemmySortType sortType = LemmySortType.topAll;

  List<String> tabTitles = [
    'Communities',
    'Posts',
    'Comments',
    'Users',
  ];

  late final List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text: widget.searchQuery,
    );

    communityCubit = SearchCubit(
      lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      searchType: SearchType.communities,
    );
    postsCubit = SearchCubit(
      lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      searchType: SearchType.posts,
    );

    commentsCubit = SearchCubit(
      lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      searchType: SearchType.comments,
    );
    usersCubit = SearchCubit(
      lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      searchType: SearchType.users,
    );

    tabs = [
      _SearchView(
        cubit: communityCubit,
      ),
      _SearchView(
        cubit: postsCubit,
      ),
      _SearchView(
        cubit: commentsCubit,
      ),
      _SearchView(
        cubit: usersCubit,
      ),
    ];

    tabController = TabController(vsync: this, length: tabs.length);
  }

  void onSearch() {
    communityCubit.search(query: textController.text, sortType: sortType);
    postsCubit.search(query: textController.text, sortType: sortType);
    commentsCubit.search(query: textController.text, sortType: sortType);
    usersCubit.search(query: textController.text, sortType: sortType);
  }

  @override
  Widget build(BuildContext context) {
    return SetPageInfo(
      actions: const [],
      page: Pages.home,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                controller: tabController,
                tabs: tabTitles.map((e) => Text(e)).toList(),
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: tabs),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  filled: false,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Search...',
                  isDense: false,
                  suffixIcon: IconButton(
                    onPressed: onSearch,
                    icon: const Icon(Icons.search),
                  ),
                ),
                focusNode: textFocusNode,
                controller: textController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView({
    required this.cubit,
    super.key,
  });

  final SearchCubit cubit;

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late SearchModel state;

  @override
  void initState() {
    super.initState();
    state = widget.cubit.state;

    widget.cubit.stream.forEach((element) {
      setState(() {
        state = element;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var bodyDisplayMode = ScrollViewBodyDisplayMode.blank;
    var footerDisplayMode = ScrollViewFooterMode.hidden;
    var indicateLoading = false;

    final hasContent = state.items.isNotEmpty;

    if (hasContent) {
      bodyDisplayMode = ScrollViewBodyDisplayMode.content;
      if (state.status == SearchStatus.loading) {
        indicateLoading = true;
      }
    } else {
      if (state.status == SearchStatus.failure) {
        bodyDisplayMode = ScrollViewBodyDisplayMode.failure;
      }
      if (state.status == SearchStatus.loading) {
        bodyDisplayMode = ScrollViewBodyDisplayMode.loading;
      }
    }

    if (state.allPagesLoaded) {
      footerDisplayMode = ScrollViewFooterMode.reachedEnd;
    }
    if (state.status == SearchStatus.loadingMore) {
      footerDisplayMode = ScrollViewFooterMode.loading;
    }
    if (state.status == SearchStatus.loadMoreFailure) {
      footerDisplayMode = ScrollViewFooterMode.failure;
    }

    return PagedScrollView(
      loadMoreThreshold: 10,
      loadMoreCallback: () {
        widget.cubit.loadNextPage();
      },
      indicateLoading: indicateLoading,
      body: ContentScrollBodyView(
        displayMode: bodyDisplayMode,
        contentSliver: SliverList.builder(
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final item = state.items[index];

            if (item is LemmyCommunity) {
              return CommunityListTile(item);
            } else if (item is LemmyPost) {
              return PostItem(
                post: item,
              );
            } else if (item is LemmyComment) {
              return CommentItem(
                comment: item,
                displayMode: CommentItemDisplayMode.single,
              );
            }

            return const SizedBox(
              height: 100,
              child: Text('No correlating item type'),
            );
          },
        ),
      ),
      footer: ContentScrollFooter(displayMode: footerDisplayMode),
    );
  }
}
