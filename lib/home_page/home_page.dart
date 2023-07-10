import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_view/card.dart';
import 'bloc/bloc.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/error.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/repo/server_repo.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  late ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(repo: context.read<ServerRepo>())
        ..add(LoadInitialPostsRequested()),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        buildWhen: (previousState, state) {
          if (previousState.pagesLoaded != state.pagesLoaded) return true;
          if (previousState.status != state.status) return true;
          if (previousState.posts != state.posts) return true;
          return false;
        },
        builder: (context, state) {
          if (state.status == HomePageStatus.loading) {
            return const LoadingComponentTransparent();
          } else if (state.status == HomePageStatus.failure) {
            return const ErrorComponentTransparent(
              message: 'Load Failed',
            );
          } else if (state.status == HomePageStatus.success) {
            return NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
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
                      context
                          .read<HomePageBloc>()
                          .add(ReachedNearEndOfScroll());
                    }
                    return true;
                  },
                  child: ListView.builder(
                      cacheExtent: 999999999999,
                      itemCount:
                          context.read<HomePageBloc>().state.posts!.length,
                      itemBuilder: (context, index) {
                        return CardLemmyPostItem(
                            context.read<HomePageBloc>().state.posts![index]
                                as LemmyPost, openContent: (post) {
                          context.goNamed('contentScreen', extra: post);
                        });
                      }),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
