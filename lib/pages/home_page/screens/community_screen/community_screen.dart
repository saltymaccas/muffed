import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/block_dialog/block_dialog.dart';
import 'package:muffed/components/icon_button.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/muffed_avatar.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/home_page/screens/community_screen/community_info_screen.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

/// The screen that displays the community including information and the
/// post view
class CommunityScreen extends StatelessWidget {
  /// initialize
  const CommunityScreen({
    this.communityId,
    this.communityName,
    this.community,
    super.key,
  }) : assert(communityId != null || communityName != null,
            'No community given: commuiityId: $communityId, communityName: $communityName');

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
    return BlocProvider(
      create: (context) => CommunityScreenBloc(
        communityId: communityId,
        community: community,
        communityName: communityName,
        repo: context.read<ServerRepo>(),
      )..add(Initialize()),
      child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
        builder: (context, state) {
          final blocContext = context;

          final bloc = BlocProvider.of<CommunityScreenBloc>(blocContext);

          return Scaffold(
            body: SetPageInfo(
              actions: [
                BlocProvider.value(
                  value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                  child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                    builder: (context, state) {
                      switch (state.communityInfoStatus) {
                        case CommunityStatus.success:
                          return IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              context.push(
                                Uri(
                                  path: '/home/search',
                                  queryParameters: {
                                    'community_id':
                                        state.community!.id.toString(),
                                    'community_name': state.community!.name,
                                  },
                                ).toString(),
                                extra: state.community,
                              );
                            },
                            icon: Icon(Icons.search),
                          );
                        case CommunityStatus.loading:
                          return const IconButtonLoading();
                        case CommunityStatus.failure:
                          return const IconButtonFailure();
                        case CommunityStatus.initial:
                          return const IconButtonInitial();
                      }
                    },
                  ),
                ),
                if (context.read<GlobalBloc>().isLoggedIn())
                  BlocProvider.value(
                    value: bloc,
                    child:
                        BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                      builder: (context, state) {
                        return IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: (state.community == null)
                              ? null
                              : () {
                                  context.push(
                                    Uri(
                                      path: '/home/create_post',
                                      queryParameters: {
                                        'community_id':
                                            state.community!.id.toString(),
                                      },
                                    ).toString(),
                                  );
                                },
                          icon: const Icon(Icons.add),
                        );
                      },
                    ),
                  ),
                BlocProvider.value(
                  value: bloc,
                  child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                    builder: (context, state) {
                      return MuffedPopupMenuButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.sort),
                        selectedValue: state.sortType,
                        items: [
                          MuffedPopupMenuItem(
                            title: 'Hot',
                            icon: const Icon(Icons.local_fire_department),
                            value: LemmySortType.hot,
                            onTap: () =>
                                context.read<CommunityScreenBloc>().add(
                                      SortTypeChanged(LemmySortType.hot),
                                    ),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Active',
                            icon: const Icon(Icons.rocket_launch),
                            value: LemmySortType.active,
                            onTap: () =>
                                context.read<CommunityScreenBloc>().add(
                                      SortTypeChanged(LemmySortType.active),
                                    ),
                          ),
                          MuffedPopupMenuItem(
                            title: 'New',
                            icon: const Icon(Icons.auto_awesome),
                            value: LemmySortType.latest,
                            onTap: () =>
                                context.read<CommunityScreenBloc>().add(
                                      SortTypeChanged(LemmySortType.latest),
                                    ),
                          ),
                          MuffedPopupMenuExpandableItem(
                            title: 'Top',
                            items: [
                              MuffedPopupMenuItem(
                                title: 'All Time',
                                icon: const Icon(Icons.military_tech),
                                value: LemmySortType.topAll,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topAll,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Year',
                                icon: const Icon(Icons.calendar_today),
                                value: LemmySortType.topYear,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topYear,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Month',
                                icon: const Icon(Icons.calendar_month),
                                value: LemmySortType.topMonth,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topMonth,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Week',
                                icon: const Icon(Icons.view_week),
                                value: LemmySortType.topWeek,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topWeek,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Day',
                                icon: const Icon(Icons.view_day),
                                value: LemmySortType.topDay,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topDay,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Twelve Hours',
                                icon: const Icon(Icons.schedule),
                                value: LemmySortType.topTwelveHour,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topTwelveHour,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Six Hours',
                                icon: const Icon(Icons.view_module_outlined),
                                value: LemmySortType.topSixHour,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topSixHour,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'Hour',
                                icon: const Icon(Icons.hourglass_bottom),
                                value: LemmySortType.topHour,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.topHour,
                                          ),
                                        ),
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
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.mostComments,
                                          ),
                                        ),
                              ),
                              MuffedPopupMenuItem(
                                title: 'New Comments',
                                icon: const Icon(Icons.add_comment),
                                value: LemmySortType.newComments,
                                onTap: () =>
                                    context.read<CommunityScreenBloc>().add(
                                          SortTypeChanged(
                                            LemmySortType.newComments,
                                          ),
                                        ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                  child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                    builder: (context, state) {
                      late Widget item;

                      if (state.communityInfoStatus ==
                          CommunityStatus.loading) {
                        item = const IconButtonLoading();
                      } else if (state.communityInfoStatus ==
                          CommunityStatus.failure) {
                        item = const IconButtonFailure();
                      } else if (state.communityInfoStatus ==
                          CommunityStatus.success) {
                        item = MuffedPopupMenuButton(
                          changeIconToSelected: false,
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.more_vert),
                          items: [
                            MuffedPopupMenuItem(
                              icon: const Icon(Icons.block),
                              title: 'Block/Unblock',
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (context) {
                                    return BlockDialog(
                                      id: state.community!.id,
                                      type: BlockDialogType.community,
                                      name: state.community!.name,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        item = const IconButtonInitial();
                      }

                      return item;
                    },
                  ),
                ),
              ],
              indexOfRelevantItem: 0,
              child: MuffedPage(
                isLoading: state.isLoading,
                error: state.errorMessage,
                child: NotificationListener(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 500) {
                      context
                          .read<CommunityScreenBloc>()
                          .add(ReachedEndOfScroll());
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<CommunityScreenBloc>().add(PullDownReload());
                      await context
                          .read<CommunityScreenBloc>()
                          .stream
                          .firstWhere((element) {
                        if (element.isReloading == false) {
                          return true;
                        }
                        return false;
                      });
                    },
                    child: CustomScrollView(
                      key: ValueKey('${state.loadedSortType}'),
                      slivers: [
                        if (state.communityInfoStatus ==
                            CommunityStatus.success)
                          SliverPersistentHeader(
                            delegate: _TopBarDelegate(
                              community: state.community!,
                              bloc: bloc,
                            ),
                            floating: false,
                            pinned: true,
                          ),
                        if (state.postsStatus == CommunityStatus.success)
                          SliverList.builder(
                            itemCount: state.posts.length,
                            itemBuilder: (context, index) {
                              return PostItem(
                                key: ValueKey(state.posts[index]),
                                post: state.posts[index],
                                limitHeight: true,
                              );
                            },
                          ),
                      ],
                    ),
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

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  const _TopBarDelegate({
    required this.community,
    required this.bloc,
  });

  final LemmyCommunity community;

  final CommunityScreenBloc bloc;

  double get headerMaxHeight => 400;
  double get headerMinHeight => 90;
  double get bannerEnd => 0.5;

  @override
  double get maxExtent => headerMaxHeight;

  @override
  double get minExtent => headerMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final fractionScrolled = shrinkOffset / headerMaxHeight;

    final placeholderBanner = Image.asset(
      'assets/placeholder_banner.jpeg',
      height: (headerMaxHeight - shrinkOffset) * bannerEnd,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.surface,
      elevation: 5,
      child: Stack(
        children: [
          Opacity(
            opacity: 1 - fractionScrolled,
            child: Stack(
              children: [
                // banner
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: (community.banner != null)
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: (headerMaxHeight - shrinkOffset) * bannerEnd,
                          placeholder: (context, url) => placeholderBanner,
                          imageUrl: community.banner!,
                        )
                      : placeholderBanner,
                ),
                // sizes to the height the the header
                SizedBox(
                  height: headerMaxHeight - shrinkOffset,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // sizes from bottom up to the fraction chosen
                      // of the header
                      SizedBox(
                        height: (headerMaxHeight - shrinkOffset) *
                            (1 - (bannerEnd - 0.05)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MuffedAvatar(url: community.icon, radius: 34),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        community.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(
                                        community.getTag(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: community.subscribers
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            TextSpan(
                                              text: ' members',
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
                                              text: ' ⋅ ',
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
                                              text: community.usersActiveDay
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            TextSpan(
                                              text: ' active',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (community.description != null)
                                Builder(
                                  builder: (context) {
                                    // gets only the first paragraph
                                    final matches =
                                        RegExp(r'^.*?\n', dotAll: true)
                                            .firstMatch(community.description!);

                                    final text = matches?.group(0) ??
                                        community.description!;

                                    return MuffedMarkdownBody(
                                      maxHeight: 104,
                                      data: text,
                                    );
                                  },
                                ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          // TODO: This is temporary for now
                                          MaterialPageRoute<void>(
                                            builder: (context) =>
                                                CommunityInfoScreen(
                                              bloc: bloc,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('See community info')),
                                  if (context.read<GlobalBloc>().isLoggedIn())
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<CommunityScreenBloc>()
                                            .add(ToggledSubscribe());
                                      },
                                      style: (community.subscribed ==
                                              LemmySubscribedType.notSubscribed)
                                          ? TextButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            )
                                          : TextButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .outlineVariant,
                                            ),
                                      child: (community.subscribed ==
                                              LemmySubscribedType.subscribed)
                                          ? Text('Unsubscribe')
                                          : (community.subscribed ==
                                                  LemmySubscribedType
                                                      .notSubscribed)
                                              ? Text('Subscribe')
                                              : Text('Pending'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: headerMaxHeight - shrinkOffset,
            width: double.maxFinite,
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Opacity(
                          opacity:
                              Curves.easeInCirc.transform(fractionScrolled),
                          child: Row(
                            children: [
                              MuffedAvatar(url: community.icon, radius: 16),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                community.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
