import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/shorthands.dart';
import 'package:muffed/view/pages/community_screen/community_screen.dart';
import 'package:muffed/view/pages/user_screen/bloc/bloc.dart';
import 'package:muffed/view/router/models/models.dart';
import 'package:muffed/view/router/models/page.dart';
import 'package:muffed/view/router/navigator/navigator.dart';
import 'package:muffed/view/widgets/block_dialog/block_dialog.dart';
import 'package:muffed/view/widgets/comment_item/comment_item.dart';
import 'package:muffed/view/widgets/error.dart';
import 'package:muffed/view/widgets/icon_button.dart';
import 'package:muffed/view/widgets/markdown_body.dart';
import 'package:muffed/view/widgets/muffed_avatar.dart';
import 'package:muffed/view/widgets/muffed_page.dart';
import 'package:muffed/view/widgets/popup_menu/popup_menu.dart';
import 'package:muffed/view/widgets/post_item/post_item.dart';

const _headerMaxHeight = 300.0;
const _headerMinHeight = 130.0;
const _bannerEndFraction = 0.6;

class UserPage extends MPage<void> {
  UserPage({this.userId, this.username});

  final int? userId;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return UserScreen(
      userId: userId,
      username: username,
    );
  }
}

/// Displays a users profile
class UserScreen extends StatelessWidget {
  /// Shows a users profile, either the id or name needs to be defined
  const UserScreen({
    super.key,
    this.userId,
    this.username,
  }) : assert(
          userId != null || username != null,
          'Both userId and username equals null',
        );

  final int? userId;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserScreenBloc(
        userId: userId,
        username: username,
        repo: context.read<ServerRepo>(),
      )..add(InitializeEvent()),
      child: BlocBuilder<UserScreenBloc, UserScreenState>(
        builder: (context, state) {
          final blocContext = context;
          return MuffedPage(
            isLoading: state.loading,
            error: state.error,
            child: DefaultTabController(
              length: 3,
              child: Builder(
                builder: (context) {
                  if (state.status == UserStatus.loading) {
                    return const _UserScreenLoading();
                  }
                  if (state.status == UserStatus.failure) {
                    return const _UserScreenFailure();
                  }
                  if (state.status == UserStatus.success) {
                    return _UserScreenSuccess(
                      user: state.user!,
                      posts: state.posts,
                      comments: state.comments,
                      isLoading: state.loading,
                    );
                  }
                  return const _UserScreenInitial();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UserScreenSuccess extends StatelessWidget {
  const _UserScreenSuccess({
    required this.user,
    required this.posts,
    required this.comments,
    required this.isLoading,
  });

  final LemmyPerson user;
  final List<LemmyPost> posts;
  final List<LemmyComment> comments;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 50 &&
            scrollInfo.metrics.axis == Axis.vertical) {
          //context.read<UserScreenBloc>().add(ReachedNearEndOfScroll());
        }
        return true;
      },
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                delegate: _HeaderDelegate(user),
                pinned: true,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    const SizedBox(
                      height: _headerMinHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Flexible(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    user.postCount.toString(),
                                    style: context.textTheme().displaySmall,
                                  ),
                                  Text(
                                    'Posts',
                                    style: context.textTheme().labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    user.commentCount.toString(),
                                    style: context.textTheme().displaySmall,
                                  ),
                                  Text(
                                    'Comments',
                                    style: context.textTheme().labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    if (user.bio != null)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: MuffedMarkdownBody(data: user.bio!),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Moderates (${user.moderates!.length})',
                        style: context.textTheme().titleMedium,
                      ),
                    ),
                  ],
                ),
                SliverList.builder(
                  itemCount: user.moderates!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: MuffedAvatar(
                        url: user.moderates![index].icon,
                        radius: 16,
                      ),
                      title: Text(
                        user.moderates![index].name,
                      ),
                      onTap: () {
                        MNavigator.of(context).pushPage(
                          CommunityPage(
                            communityId: user.moderates![index].id,
                          ),
                        );
                        Navigator.of(context).push(
                          CommunityPage(
                            communityId: user.moderates![index].id,
                          ).createRoute(context),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            ListView.builder(
              itemCount: posts.length + 1,
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
                  post: posts[index - 1],
                );
              },
            ),
            ListView.builder(
              key: const PageStorageKey('comments'),
              itemCount: comments.length + 1,
              itemBuilder: (context, index) {
                // There is a bug that makes the header overlap the contents
                // this moves the content down so it does not overlap
                if (index == 0) {
                  return const SizedBox(
                    height: _headerMinHeight,
                  );
                }
                return CommentItem(
                  displayMode: CommentItemDisplayMode.single,
                  comment: comments[index - 1],
                  sortType: LemmyCommentSortType.hot,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CommunitiesModerates extends StatelessWidget {
  const CommunitiesModerates({this.communities, super.key});

  final List<LemmyCommunity>? communities;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate(this.user);

  @override
  double get maxExtent => _headerMaxHeight;

  @override
  double get minExtent => _headerMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  final LemmyPerson user;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final placeholderBanner = Image.asset(
      'assets/placeholder_banner.jpeg',
      height: (_headerMaxHeight - shrinkOffset) * _bannerEndFraction,
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
                      return const LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height),
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: (user.banner != null)
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: (_headerMaxHeight - shrinkOffset) *
                                _bannerEndFraction,
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          child: MuffedAvatar(
                            url: user.avatar,
                          ),
                        ),
                        SizedBox(
                          height: (_headerMaxHeight - shrinkOffset) *
                              (1 - _bannerEndFraction),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(user.getTag()),
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
            Container(
              height: _headerMaxHeight - shrinkOffset,
              width: double.maxFinite,
              color: Theme.of(context).colorScheme.surface.withOpacity(
                    shrinkOffset / (_headerMaxHeight - _headerMinHeight),
                  ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
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
}

class _UserScreenInitial extends StatelessWidget {
  const _UserScreenInitial();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class _UserScreenLoading extends StatelessWidget {
  const _UserScreenLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _UserScreenFailure extends StatelessWidget {
  const _UserScreenFailure();

  @override
  Widget build(BuildContext context) {
    return ErrorComponentTransparent(
      retryFunction: () {
        context.read<UserScreenBloc>().add(InitializeEvent());
      },
      error: context.read<UserScreenBloc>().state.error ?? '',
    );
  }
}
