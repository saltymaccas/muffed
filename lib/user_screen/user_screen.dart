import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muffed/comment_screen/comment_view/comment.dart';
import 'package:muffed/components/block_dialog/block_dialog.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/icon_button.dart';
import 'package:muffed/components/popup_menu/popup_menu.dart';
import 'package:muffed/content_view/post_item/post_view_modes/card.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

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
                                    });
                              },
                            )
                          ]);
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
              child: Scaffold(
                appBar: AppBar(
                  //title: Text(state.username ?? state.user?.displayName ?? ''),
                  bottom: const TabBar(
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
                ),
                body: <UserStatus, Widget>{
                  UserStatus.loading: _UserScreenLoading(),
                  UserStatus.initial: _UserScreenInitial(),
                  UserStatus.failure: _UserScreenFailure(),
                  UserStatus.success: _UserScreenSuccess(
                    state: state,
                  ),
                }[state.status],
              ),
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
                    scrollInfo.metrics.maxScrollExtent - 500 &&
                scrollInfo.metrics.axis == Axis.vertical) {
              context.read<UserScreenBloc>().add(ReachedNearEndOfScroll());
            }
            return true;
          },
          child: TabBarView(
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
                            borderRadius: BorderRadius.all(Radius.circular(45)),
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
                key: const PageStorageKey('posts'),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return CardLemmyPostItem(
                    state.posts[index],
                  );
                },
              ),
              ListView.builder(
                key: const PageStorageKey('comments'),
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  return CommentItem(
                    comment: state.comments[index],
                    onReplyPressed: (_, __) {},
                  );
                },
              ),
            ],
          ),
        ),
        if (state.loading) LinearProgressIndicator(),
      ],
    );
  }
}
