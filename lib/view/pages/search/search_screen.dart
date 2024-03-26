import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/view/pages/community/community_screen.dart';
import 'package:muffed/view/pages/search/bloc/bloc.dart';
import 'package:muffed/view/router/models/page.dart';
import 'package:muffed/view/widgets/comment/comment.dart';
import 'package:muffed/view/widgets/community/community.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/view/widgets/post/post_item.dart';

class SearchPage extends MPage<void> {
  SearchPage({this.searchQuery, this.communityId, this.communityName});
  final String? searchQuery;

  final String? communityName;
  final int? communityId;

  @override
  Widget build(BuildContext context) {
    return SearchScreen(
      searchQuery: searchQuery,
      communityId: communityId,
      communityName: communityName,
    );
  }
}

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

  late final SearchBloc communityBloc;
  late final SearchBloc usersBloc;
  late final SearchBloc commentsBloc;
  late final SearchBloc postsBloc;

  late final TabController tabController;

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

    textFocusNode.requestFocus();

    final lemmyRepo = context.read<LemmyRepo>();

    communityBloc = SearchBloc(
      lem: lemmyRepo,
      searchType: SearchType.communities,
    );
    postsBloc = SearchBloc(
      lem: lemmyRepo,
      searchType: SearchType.posts,
    );

    commentsBloc = SearchBloc(
      lem: lemmyRepo,
      searchType: SearchType.comments,
    );
    usersBloc = SearchBloc(
      lem: lemmyRepo,
      searchType: SearchType.users,
    );

    tabs = [
      _SearchView(
        bloc: communityBloc,
      ),
      _SearchView(
        bloc: postsBloc,
      ),
      _SearchView(
        bloc: commentsBloc,
      ),
      _SearchView(
        bloc: usersBloc,
      ),
    ];

    tabController = TabController(vsync: this, length: tabs.length);
  }

  void onBackPressed(BuildContext context) {
    if (textFocusNode.hasFocus) {
      textFocusNode.unfocus();
    } else {
      Navigator.pop(context);
    }
  }

  void onSearch() {
    textFocusNode.unfocus();
    search();
  }

  void search() {
    communityBloc.add(Searched(query: textController.text));
    postsBloc.add(Searched(query: textController.text));
    commentsBloc.add(Searched(query: textController.text));
    usersBloc.add(Searched(query: textController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onBackPressed(context);
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
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView({
    required this.bloc,
    super.key,
  });

  final SearchBloc bloc;

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final SearchBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
  }

  Widget itemBuilder(BuildContext context, Object item) {
    if (item is Community) {
      return CommunityListTile(
        item,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => CommunityScreen(
                communityId: item.id,
              ),
            ),
          );
        },
      );
    } else if (item is PostView) {
      return PostWidget(
        post: item,
      );
    } else if (item is Comment) {
      return const Placeholder();
    }

    return const SizedBox(
      height: 100,
      child: Text('No correlating item type'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: bloc,
      builder: (context, state) {
        return PagedScroll(
          status: state.status,
          items: state.items,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
