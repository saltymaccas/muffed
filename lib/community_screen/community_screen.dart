import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/icon_button.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/components/muffed_avatar.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/block_dialog/block_dialog.dart';
import '../components/popup_menu/popup_menu.dart';
import '../global_state/bloc.dart';
import 'bloc/bloc.dart';

/// The screen that displays the community including information and the
/// post view
class CommunityScreen extends StatelessWidget {
  /// initialize
  const CommunityScreen({required this.communityId, this.community, super.key});

  /// The community ID
  final int communityId;

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
        repo: context.read<ServerRepo>(),
      )..add(Initialize()),
      child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
        builder: (context, state) {
          final blocContext = context;

          void showAboutDialog() {
            showDialog<void>(
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: BlocProvider.of<CommunityScreenBloc>(
                    blocContext,
                  ),
                  child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                    builder: (context, state) {
                      if (state.community != null) {
                        return Dialog(
                          child: Markdown(
                            shrinkWrap: true,
                            data: state.community!.description ??
                                'no description',
                            selectable: true,
                            onTapLink: (text, url, title) {
                              launchUrl(Uri.parse(url!));
                            },
                          ),
                        );
                      } else {
                        return const Dialog(
                          child: Text('community still loading'),
                        );
                      }
                    },
                  ),
                );
                final state = context.read<CommunityScreenBloc>().state;
              },
            );
          }

          return SetPageInfo(
            actions: [
              BlocProvider.value(
                value: BlocProvider.of<CommunityScreenBloc>(blocContext),
                child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
                  builder: (context, state) {
                    return MuffedPopupMenuButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.sort),
                      selectedValue: state.sortType,
                      items: [
                        MuffedPopupMenuItem(
                          title: 'Hot',
                          icon: Icon(Icons.local_fire_department),
                          value: LemmySortType.hot,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.hot),
                              ),
                        ),
                        MuffedPopupMenuItem(
                          title: 'Active',
                          icon: Icon(Icons.rocket_launch),
                          value: LemmySortType.active,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.active),
                              ),
                        ),
                        MuffedPopupMenuItem(
                          title: 'New',
                          icon: Icon(Icons.auto_awesome),
                          value: LemmySortType.latest,
                          onTap: () => context.read<CommunityScreenBloc>().add(
                                SortTypeChanged(LemmySortType.latest),
                              ),
                        ),
                        MuffedPopupMenuExpandableItem(
                          title: 'Top',
                          items: [
                            MuffedPopupMenuItem(
                              title: 'All Time',
                              icon: Icon(Icons.military_tech),
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
                              icon: Icon(Icons.calendar_today),
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
                              icon: Icon(Icons.calendar_month),
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
                              icon: Icon(Icons.view_week),
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
                              icon: Icon(Icons.view_day),
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
                              icon: Icon(Icons.schedule),
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
                              icon: Icon(Icons.view_module_outlined),
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
                              icon: Icon(Icons.hourglass_bottom),
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
                              icon: Icon(Icons.comment_bank),
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
                              icon: Icon(Icons.add_comment),
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

                    if (state.communityInfoStatus == CommunityStatus.loading) {
                      item = const IconButtonLoading();
                    } else if (state.communityInfoStatus ==
                        CommunityStatus.failure) {
                      item = const IconButtonFailure();
                    } else if (state.communityInfoStatus ==
                        CommunityStatus.success) {
                      item = MuffedPopupMenuButton(
                          changeIconToSelected: false,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.more_vert),
                          items: [
                            MuffedPopupMenuItem(
                              icon: Icon(Icons.block),
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
                                    });
                              },
                            ),
                          ]);
                    } else {
                      item = IconButtonInitial();
                    }

                    return item;
                  },
                ),
              )
            ],
            indexOfRelevantItem: 0,
            // makes presses outside of the menu not register and closes the
            // menu
            child: ContentView(
              scrollController: ScrollController(),
              leadingSlivers: [
                if (state.communityInfoStatus == CommunityStatus.success)
                  SliverPersistentHeader(
                    delegate: _TopBarDelegate(community: state.community!),
                    floating: false,
                    pinned: true,
                  ),
              ],
              onRefresh: () async {},
              isContentLoading: state.postsStatus == CommunityStatus.loading,
              posts: state.posts,
              reachedNearEnd: () {
                context.read<CommunityScreenBloc>().add(ReachedEndOfScroll());
              },
            ),
          );
        },
      ),
    );
  }
}

//  TODO: make a better header

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  final LemmyCommunity community;

  _TopBarDelegate({required this.community});

  final _headerMaxHeight = 400.0;
  final _headerMinHeight = 90.0;
  final bannerEnd = 0.5;

  @override
  double get maxExtent => _headerMaxHeight;

  @override
  double get minExtent => _headerMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;

    final fractionScrolled = shrinkOffset / _headerMaxHeight;

    final placeholderBanner = Image.asset(
      'assets/placeholder_banner.jpeg',
      height: (_headerMaxHeight - shrinkOffset) * bannerEnd,
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
            child: SingleChildScrollView(
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
                            height:
                                (_headerMaxHeight - shrinkOffset) * bannerEnd,
                            placeholder: (context, url) => placeholderBanner,
                            imageUrl: community.banner!,
                          )
                        : placeholderBanner,
                  ),
                  // sizes to the height the the header
                  SizedBox(
                    height: _headerMaxHeight - shrinkOffset,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stops the avatar from overlapping with the pinned top
                        // bar
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          child: MuffedAvatar(url: community.icon, radius: 34),
                        ),
                        // sizes from bottom up to the fraction chosen
                        // of the header
                        SizedBox(
                          height: (_headerMaxHeight - shrinkOffset) *
                              (1 - bannerEnd),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // title
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      community.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    // Subscribe button
                                    if (context.read<GlobalBloc>().isLoggedIn())
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<CommunityScreenBloc>()
                                              .add(ToggledSubscribe());
                                        },
                                        style: (community.subscribed ==
                                                LemmySubscribedType
                                                    .notSubscribed)
                                            ? TextButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                              )
                                            : TextButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                foregroundColor:
                                                    Theme.of(context)
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
                                if (community.description != null)
                                  MuffedMarkdownBody(
                                    data: community.description!,
                                    height: 104,
                                  ),
                                if (community.description != null)
                                  TextButton(
                                      onPressed: () {},
                                      child: Text('View full description')),
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
          ),
          SizedBox(
            height: _headerMaxHeight - shrinkOffset,
            width: double.maxFinite,
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Opacity(
                      opacity: fractionScrolled,
                      child: Text(community.title),
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
