import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_view/card.dart';
import 'bloc/bloc.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/error.dart';
import 'package:go_router/go_router.dart';
import 'content_screen/content_screen.dart';
import 'package:muffed/repo/server_repo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      HomePageBloc(repo: context.read<ServerRepo>())
        ..add(LoadInitialPostsRequested()),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        buildWhen: (previousState, state) {
          if (previousState.pagesLoaded != state.pagesLoaded) return true;
          if (previousState.status != state.status) return true;
          if (previousState.posts != state.posts) return true;
          return false;
        },
        builder: (context, state) {
          return (state.status == HomePageStatus.loading)
              ? const LoadingComponentTransparent()
              : (state.status == HomePageStatus.failure)
              ? const ErrorComponentTransparent()
              : (state.status == HomePageStatus.success)
              ? FeedView()
              : Container();
        },
      ),
    );
  }
}

class FeedView extends StatelessWidget {
  FeedView({
    super.key,
  });

  late ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            elevation: 2,
            floating: true,
            title: Text('Feed'),
          )
        ];
      },
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomePageBloc>().add(PullDownRefresh());
          await context
              .read<HomePageBloc>()
              .stream
              .firstWhere((element) {
            if (element.isRefreshing == false) {
              return true;
            }
            return false;
          });
        },
        child: NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              context.read<HomePageBloc>().add(ReachedNearEndOfScroll());
            }
            return true;
          },
          child: ListView.builder(
              cacheExtent: 999999999999,
              itemCount: context
                  .read<HomePageBloc>()
                  .state
                  .posts!
                  .length,
              itemBuilder: (context, index) {
                return CardLemmyPostItem(context
                    .read<HomePageBloc>()
                    .state
                    .posts![index] as LemmyPost,openContent: (post) {
                  context.goNamed(
                      'contentScreen', extra: post);
                }
                );
              }),
        ),
      ),
    );
  }
}
