import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/content_screen/content_screen.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';
import '../enums.dart';
import 'bloc/bloc.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({required this.communityId, this.community, super.key});

  final int communityId;
  final LemmyCommunity? community;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return SetPageInfo(
      actions: [
        MenuAnchor(
            childFocusNode: FocusNode(),
            onOpen: () {
              setState(() {
                menuOpen = true;
              });
            },
            onClose: () {
              setState(() {
                menuOpen = false;
              });
            },
            menuChildren: [
              MenuItemButton(
                child: Text('test'),
                onPressed: () {},
              )
            ],
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  if (!controller.isOpen) {
                    controller.open();
                  } else {
                    controller.close();
                  }
                },
                icon: Icon(Icons.more_vert),
                visualDensity: VisualDensity.compact,
              );
            }),
      ],
      itemIndex: 0,
      child: AbsorbPointer(
        absorbing: menuOpen,
        child: BlocProvider(
          create: (context) => CommunityScreenBloc(
              communityId: widget.communityId,
              community: widget.community,
              repo: context.read<ServerRepo>())
            ..add(Initialize()),
          child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
            builder: (context, state) {
              return ContentView(
                headerDelegate:
                    (state.communityInfoStatus == ScreenStatus.success)
                        ? _TopBarDelegate(community: state.communityInfo!)
                        : null,
                floatingHeader: true,
                pinnedHeader: false,
                isContentLoading: state.postsStatus == ScreenStatus.loading,
                onPressedPost: (post) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ContentScreen(post);
                  }));
                },
                posts: state.posts,
                reachedEnd: () {
                  context.read<CommunityScreenBloc>().add(ReachedEndOfScroll());
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
  final LemmyCommunity community;

  _TopBarDelegate({required this.community});

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(community.name,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: 1 - progress,
            child: (community.banner != null)
                ? Image.network(
                    community.banner!,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
