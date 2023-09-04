import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/comment_screen/comment_view/comment.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/content_view/post_view/card.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/user_screen/bloc/bloc.dart';

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
      create: (context) =>
      UserScreenBloc(
          userId: userId, username: username, repo: context.read<ServerRepo>())
        ..add(InitializeEvent()),
      child: BlocBuilder<UserScreenBloc, UserScreenState>(
          builder: (context, state) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(state.username ?? state.user?.displayName ?? ''),
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        text: 'Posts',
                      ),
                      Tab(
                        text: 'Comments',
                      ),
                      Tab(
                        text: 'About',
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
            );
          }),
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
      retryFunction: () =>
          context.read<UserScreenBloc>().add(InitializeEvent()),
      message: context
          .read<UserScreenBloc>()
          .state
          .errorMessage ?? '',
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

            }
            return true;
          },
          child: TabBarView(
            children: [
              ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return CardLemmyPostItem(state.posts[index]);
                },
              ),
              ListView.builder(
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  return CommentItem(
                    comment: state.comments[index],
                    onReplyPressed: (_, __) {},
                  );
                },
              ),
              Placeholder(),
            ],
          ),
        ),
        if (state.loading) LinearProgressIndicator(),
      ],
    );
  }
}
