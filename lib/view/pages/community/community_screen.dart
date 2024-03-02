import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/community/bloc/bloc.dart';
import 'package:muffed/view/pages/community/bloc/scroll/scroll.dart';
import 'package:muffed/view/pages/community/models/models.dart';
import 'package:muffed/view/pages/community/widgets/header.dart';
import 'package:muffed/view/router/models/page.dart';
import 'package:muffed/view/router/models/page_actions.dart';
import 'package:muffed/view/widgets/content_scroll_view/bloc/bloc.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/view/widgets/content_scroll_view/view/view.dart';
import 'package:muffed/view/widgets/lemmy_sort_menu/lemmy_sort_menu.dart';
import 'package:muffed/view/widgets/muffed_page.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';

export 'models/models.dart';

class CommunityPage extends MPage<void> {
  CommunityPage({
    this.communityId,
    this.communityName,
    this.community,
  });

  final int? communityId;
  final String? communityName;
  final LemmyCommunity? community;

  @override
  Widget build(BuildContext context) {
    return CommunityScreen(
      communityId: communityId,
      communityName: communityName,
      community: community,
    );
  }
}

/// Displays a specified community and its posts
class CommunityScreen extends StatefulWidget {
  /// initialize
  CommunityScreen({
    int? communityId,
    String? communityName,
    this.community,
    super.key,
  })  : communityId = communityId ?? community?.id,
        communityName = communityName ?? community?.name,
        assert(
          communityId != null || communityName != null || community != null,
          'No community defined',
        );

  /// The community ID
  final int? communityId;

  /// The community name
  final String? communityName;

  /// The community object which contains the community information.
  ///
  /// If this is set to null the information will be loaded from the API.
  /// Setting the value will mean the community information can be shown
  /// instantly
  final LemmyCommunity? community;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late final CommunityBloc communityBloc;
  late final CommunityScrollBloc scrollBloc;

  @override
  void initState() {
    super.initState();

    communityBloc = CommunityBloc(
      lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      communityId: widget.communityId,
      community: widget.community,
    )..add(Initialised());
    scrollBloc = CommunityScrollBloc(
      lemmyRepo: context.read<ServerRepo>().lemmyRepo,
      communityId: widget.communityId!,
    )..add(ScrollInitialised());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CommunityScrollBloc, CommunityScrollState>(
        bloc: scrollBloc,
        builder: (context, state) {
          return PagedScroll(
            headerSlivers: [
              BlocBuilder<CommunityBloc, CommunityState>(
                bloc: communityBloc,
                builder: (context, state) {
                  return SliverCommunityPageViewHeader(
                    community: state.community,
                  );
                },
              ),
            ],
            status: state.status,
            items: state.posts,
            itemBuilder: (context, item) {
              if (item is LemmyPost) {
                return PostItem(post: item);
              } else {
                return SizedBox(
                  height: 200,
                  width: 200,
                  child: Placeholder(
                    child: Text(
                        'widget err: item of ${item.runtimeType} type not recognised'),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
