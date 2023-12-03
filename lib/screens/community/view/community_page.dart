import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/screens/community/community.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({
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

  final PageActions pageActions = PageActions([Icon(Icons.search)]);

  MuffedPage<void> page() => MuffedPage<void>(
        child: this,
        pageActions: pageActions,
      );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageActions.setActions([Icon(Icons.search), Icon(Icons.more_vert)]);
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunityScreenBloc>(
          create: (context) => CommunityScreenBloc(
            communityId: communityId,
            community: community,
            communityName: communityName,
            repo: context.read<ServerRepo>(),
          )..add(InitialiseCommunityScreen()),
        ),
        BlocProvider<ContentScrollBloc>(
          create: (context) => ContentScrollBloc(
            retrieveContent: CommunityScreenContentRetriever(
              sortType: LemmySortType.hot,
              repo: context.read<ServerRepo>(),
              communityId: communityId,
            ),
          )..add(Initialise()),
        ),
      ],
      child: const CommunityView(),
    );
  }
}
