import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:muffed/components/cards.dart';

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
                      if (state.communityInfo != null) {
                        return Dialog(
                          child: Markdown(
                            shrinkWrap: true,
                            data: state.communityInfo!.description ??
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
              MuffedPopupMenuButton(
                icon: Icon(Icons.more_vert),
                visualDensity: VisualDensity.compact,
                items: [
                  MuffedPopupMenuItem(
                    title: 'About',
                    onTap: showAboutDialog,
                  ),
                ],
              ),
            ],
            indexOfRelevantItem: 0,
            // makes presses outside of the menu not register and closes the
            // menu
            child: ContentView(
              scrollController: ScrollController(),
              leadingSlivers: [
                if (state.communityInfoStatus == CommunityStatus.success)
                  SliverPersistentHeader(
                    delegate: _TopBarDelegate(community: state.communityInfo!),
                    floating: false,
                    pinned: false,
                  ),
              ],
              onRefresh: () async {},
              isContentLoading: state.postsStatus == CommunityStatus.loading,
              onPressedPost: (post) {
                context.push('/home/content', extra: post);
              },
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

  @override
  double get maxExtent => 600;

  @override
  double get minExtent => 0;

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

    return SafeArea(
      child: LemmyCommunityCard(community: community,),
    );
  }
}
