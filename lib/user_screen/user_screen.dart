import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/block_dialog/block_dialog.dart';
import 'package:muffed/components/comment_item/comment_item.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/icon_button.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/components/post_item/post_item.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

const _headerMaxHeight = 500.0;
const _headerMinHeight = 130.0;

/// Displays a users profile
class UserScreen extends StatelessWidget {
  const UserScreen({
    super.key,
    this.userId,
    this.username,
  }) : assert(userId != null || username != null,
            'Both userId and username equals null');

  final int? userId;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserScreenBloc(
          userId: userId, username: username, repo: context.read<ServerRepo>())
        ..add(InitializeEvent()),
      child: BlocBuilder<UserScreenBloc, UserScreenState>(
        builder: (context, state) {
          final blocContext = context;
          return SetPageInfo(
            indexOfRelevantItem: 0,
            actions: [
              BlocProvider.value(
                value: BlocProvider.of<UserScreenBloc>(blocContext),
                child: BlocBuilder<UserScreenBloc, UserScreenState>(
                  builder: (context, state) {
                    late Widget item;

                    if (state.status == UserStatus.loading) {
                      item = const IconButtonLoading();
                    } else if (state.status == UserStatus.failure) {
                      item = const IconButtonFailure();
                    } else if (state.status == UserStatus.success) {
                      item = MuffedPopupMenuButton(
                        changeIconToSelected: false,
                        icon: Icon(Icons.more_vert),
                        visualDensity: VisualDensity.compact,
                        items: [
                          MuffedPopupMenuItem(
                            icon: Icon(Icons.block),
                            title: 'Block/Unblock',
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return BlockDialog(
                                    id: state.user!.id,
                                    type: BlockDialogType.person,
                                    name: state.user!.name,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      item = SizedBox();
                    }

                    return AnimatedSwitcher(
                      duration: Duration(
                        milliseconds: 200,
                      ),
                      child: item,
                    );
                  },
                ),
              )
            ],
            child: DefaultTabController(
              length: 3,
              child: <UserStatus, Widget>{
                UserStatus.loading: _UserScreenLoading(),
                UserStatus.initial: _UserScreenInitial(),
                UserStatus.failure: _UserScreenFailure(),
                UserStatus.success: _UserScreenSuccess(
                  state: state,
                ),
              }[state.status]!,
            ),
          );
        },
      ),
    );
  }
}

class _UserScreenInitial extends StatelessWidget {
  const _UserScreenInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

class _UserScreenLoading extends StatelessWidget {
  const _UserScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _UserScreenFailure extends StatelessWidget {
  const _UserScreenFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorComponentTransparent(
      retryFunction: () {
        context.read<UserScreenBloc>().add(InitializeEvent());
      },
      message: context.read<UserScreenBloc>().state.errorMessage ?? '',
    );
  }
}

class _UserScreenSuccess extends StatelessWidget {
  const _UserScreenSuccess({super.key, required this.state});

  final UserScreenState state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 50 &&
                scrollInfo.metrics.axis == Axis.vertical) {
              //context.read<UserScreenBloc>().add(ReachedNearEndOfScroll());
            }
            return true;
          },
          child: NestedScrollView(
            floatHeaderSlivers: false,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPersistentHeader(
                    delegate: _HeaderDelegate(state.user!),
                    pinned: true,
                    floating: false,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        image: (state.user!.banner != null)
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                opacity: 0.5,
                                image: CachedNetworkImageProvider(
                                  state.user!.banner!,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: 50,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              child: (state.user!.avatar != null)
                                  ? CachedNetworkImage(
                                      imageUrl: state.user!.avatar!,
                                    )
                                  : SvgPicture.asset('assets/logo.svg'),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Text(
                            state.user!.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  itemCount: state.posts.length + 1,
                  key: const PageStorageKey('posts'),
                  itemBuilder: (context, index) {
                    // There is a bug that makes the header overlap the contents
                    // this moves the content down so it does not overlap
                    if (index == 0) {
                      return const SizedBox(
                        height: _headerMinHeight,
                      );
                    }
                    return PostItem(
                      post: state.posts[index - 1],
                    );
                  },
                ),
                ListView.builder(
                  key: const PageStorageKey('comments'),
                  itemCount: state.comments.length + 1,
                  itemBuilder: (context, index) {
                    // There is a bug that makes the header overlap the contents
                    // this moves the content down so it does not overlap
                    if (index == 0) {
                      return const SizedBox(
                        height: _headerMinHeight,
                      );
                    }
                    return CommentItem(
                      comment: state.comments[index - 1],
                      children: const [],
                      sortType: LemmyCommentSortType.hot,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (state.loading) LinearProgressIndicator(),
      ],
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate(this.user);

  final LemmyPerson user;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final placeholderBanner = Image.asset(
      'assets/placeholder_banner.jpeg',
      height: (_headerMaxHeight - shrinkOffset) / 2,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.surface,
        elevation: 5,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: (user.banner != null)
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: (_headerMaxHeight - shrinkOffset) / 2,
                            placeholder: (context, url) => placeholderBanner,
                            imageUrl: user.banner!,
                          )
                        : placeholderBanner,
                  ),
                  SizedBox(
                    height: _headerMaxHeight - shrinkOffset,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          child: CircleAvatar(
                            maxRadius: 50,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              child: (user.avatar != null)
                                  ? CachedNetworkImage(
                                      imageUrl: user.avatar!,
                                    )
                                  : SvgPicture.asset('assets/logo.svg'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (_headerMaxHeight - shrinkOffset) / 2,
                          child: Column(
                            children: [
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _headerMaxHeight - shrinkOffset,
              width: double.maxFinite,
              color: Theme.of(context).colorScheme.surface.withOpacity(
                    shrinkOffset / (_headerMaxHeight - _headerMinHeight),
                  ),
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
                        opacity: shrinkOffset /
                            (_headerMaxHeight - _headerMinHeight),
                        child: Text(user.name),
                      ),
                    ],
                  ),
                  const TabBar(
                    tabs: [
                      Tab(
                        text: 'About',
                      ),
                      Tab(
                        text: 'Posts',
                      ),
                      Tab(
                        text: 'Comments',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => _headerMaxHeight;

  @override
  double get minExtent => _headerMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
