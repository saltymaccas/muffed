import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_view/card.dart';
import 'bloc/bloc.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/error.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/search_page/search_page.dart';

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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomePageBloc>().add(PullDownRefresh());
                await context.read<HomePageBloc>().stream.firstWhere((element) {
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
                child: CustomScrollView(
                  cacheExtent: 99999999,
                  slivers: [
                    SliverPersistentHeader(
                        floating: true, delegate: TopBarDelegate()),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: state.posts!.length, (context, index) {
                      return CardLemmyPostItem(
                          context.read<HomePageBloc>().state.posts![index]
                              as LemmyPost, openContent: (post) {
                        context.goNamed('contentScreen', extra: post);
                      });
                    }))
                  ],
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

class TopBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 200.0;

  @override
  double get maxExtent => 200.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  context.goNamed('searchPage');
                },
                icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
          ],
        )),
      ),
    );
  }

  @override
  bool shouldRebuild(TopBarDelegate oldDelegate) => false;
}
