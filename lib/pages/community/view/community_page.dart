import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/search/search.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/widgets/content_scroll/bloc/bloc.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

class CommunityPage extends MPage<void> {
  CommunityPage({
    int? communityId,
    String? communityName,
    this.community,
  })  : communityId = communityId ?? community?.id,
        communityName = communityName ?? community?.name,
        assert(
          communityId != null || communityName != null || community != null,
          'No community defined',
        ),
        super(pageActions: PageActions([]));

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
  Widget build(BuildContext context) {
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
        BlocProvider<ContentScrollBloc<LemmyPost>>(
          create: (context) => ContentScrollBloc(
            contentRetriever: CommunityScreenPostRetrieverDelegate(
              sortType: LemmySortType.hot,
              repo: context.read<ServerRepo>(),
              communityId: communityId,
            ),
          )..add(LoadInitialItems()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final contentScrollBloc =
              context.read<ContentScrollBloc<LemmyPost>>();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            void changeSortType(LemmySortType sortType) {
              context.read<ContentScrollBloc<LemmyPost>>().add(
                    RetrieveContentDelegateChanged(
                      (contentScrollBloc.state.contentDelegate
                              as CommunityScreenPostRetrieverDelegate)
                          .copyWith(sortType: sortType),
                    ),
                  );
            }

            pageActions!.setActions([
              IconButton(
                onPressed: () {
                  context.pushPage(
                    SearchPage(
                      communityId:
                          context.read<CommunityScreenBloc>().communityId,
                      communityName:
                          context.read<CommunityScreenBloc>().communityName,
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                visualDensity: VisualDensity.compact,
              ),
              BlocBuilder<ContentScrollBloc<LemmyPost>,
                  ContentScrollState<LemmyPost>>(
                bloc: contentScrollBloc,
                builder: (context, state) {
                  return MuffedPopupMenuButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.sort),
                    selectedValue: (state.contentDelegate
                            as CommunityScreenPostRetrieverDelegate)
                        .sortType,
                    items: [
                      MuffedPopupMenuItem(
                        title: 'Hot',
                        icon: const Icon(Icons.local_fire_department),
                        value: LemmySortType.hot,
                        onTap: () => changeSortType(LemmySortType.hot),
                      ),
                      MuffedPopupMenuItem(
                        title: 'Active',
                        icon: const Icon(Icons.rocket_launch),
                        value: LemmySortType.active,
                        onTap: () => changeSortType(LemmySortType.active),
                      ),
                      MuffedPopupMenuItem(
                        title: 'New',
                        icon: const Icon(Icons.auto_awesome),
                        value: LemmySortType.latest,
                        onTap: () => changeSortType(LemmySortType.latest),
                      ),
                      MuffedPopupMenuExpandableItem(
                        title: 'Top',
                        items: [
                          MuffedPopupMenuItem(
                            title: 'All Time',
                            icon: const Icon(Icons.military_tech),
                            value: LemmySortType.topAll,
                            onTap: () => changeSortType(LemmySortType.topAll),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Year',
                            icon: const Icon(Icons.calendar_today),
                            value: LemmySortType.topYear,
                            onTap: () => changeSortType(LemmySortType.topYear),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Month',
                            icon: const Icon(Icons.calendar_month),
                            value: LemmySortType.topMonth,
                            onTap: () => changeSortType(LemmySortType.topMonth),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Week',
                            icon: const Icon(Icons.view_week),
                            value: LemmySortType.topWeek,
                            onTap: () => changeSortType(LemmySortType.topWeek),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Day',
                            icon: const Icon(Icons.view_day),
                            value: LemmySortType.topDay,
                            onTap: () => changeSortType(LemmySortType.topDay),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Twelve Hours',
                            icon: const Icon(Icons.schedule),
                            value: LemmySortType.topTwelveHour,
                            onTap: () =>
                                changeSortType(LemmySortType.topTwelveHour),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Six Hours',
                            icon: const Icon(Icons.view_module_outlined),
                            value: LemmySortType.topSixHour,
                            onTap: () =>
                                changeSortType(LemmySortType.topSixHour),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Hour',
                            icon: const Icon(Icons.hourglass_bottom),
                            value: LemmySortType.topHour,
                            onTap: () => changeSortType(LemmySortType.topHour),
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
                                changeSortType(LemmySortType.mostComments),
                          ),
                          MuffedPopupMenuItem(
                            title: 'New Comments',
                            icon: const Icon(Icons.add_comment),
                            value: LemmySortType.newComments,
                            onTap: () =>
                                changeSortType(LemmySortType.newComments),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ]);
          });
          return const CommunityView();
        },
      ),
    );
  }
}
