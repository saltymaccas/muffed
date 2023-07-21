import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/content_view/post_view/card.dart';
import 'bloc/bloc.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/components/error.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/search_dialog/search_dialog.dart';
import 'package:muffed/content_view/content_view.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  late final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(repo: context.read<ServerRepo>())
        ..add(LoadInitialPostsRequested()),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          if (state.status == HomePageStatus.loading) {
            return const LoadingComponentTransparent();
          } else if (state.status == HomePageStatus.failure) {
            return const ErrorComponentTransparent(
              message: 'Load Failed',
            );
          } else if (state.status == HomePageStatus.success) {
            return SetPageInfo(
              itemIndex: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    openSearchDialog(context);
                  },
                  icon: Icon(Icons.search_rounded),
                  visualDensity: VisualDensity.compact,
                ),
              ],
              child: RefreshIndicator(
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
                child: ContentView(
                  reachedEnd: () {
                    context
                        .read<HomePageBloc>()
                        .add(ReachedNearEndOfScroll());
                  },
                  onPressedPost: (post) {context.go('/home/content', extra: post);},
                  posts: context.read<HomePageBloc>().state.posts!,
                  floatingHeader: false,
                  headerDelegate: _TopBarDelegate(),
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

class _TopBarDelegate extends SliverPersistentHeaderDelegate {
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
      ),
    );
  }

  @override
  bool shouldRebuild(_TopBarDelegate oldDelegate) => false;
}
