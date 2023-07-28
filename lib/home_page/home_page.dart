import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/error.dart';
import 'package:muffed/components/loading.dart';
import 'package:muffed/content_view/content_view.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/search_dialog/search_dialog.dart';

import 'bloc/bloc.dart';

/// The main page the user uses the scroll through content
class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(repo: context.read<ServerRepo>())
        ..add(LoadInitialPostsRequested()),
      child: BlocListener<GlobalBloc, GlobalState>(
        listenWhen: (previous, current) {
          // checks whether the account has changed

          late LemmyAccountData? previousAccount;

          if (previous.lemmySelectedAccount == null) {
            previousAccount = null;
          } else {
            previousAccount =
                previous.lemmyAccounts[previous.lemmySelectedAccount!];
          }

          late LemmyAccountData? currentAccount;

          if (current.lemmySelectedAccount == null) {
            currentAccount = null;
          } else {
            currentAccount =
                current.lemmyAccounts[current.lemmySelectedAccount!];
          }

          if (previousAccount != currentAccount) {
            return true;
          }

          return false;
        },
        listener: (context, state) {
          context.read<HomePageBloc>().add(AccountChanged());
        },
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state.status == HomePageStatus.loading) {
              return const LoadingComponentTransparent();
            } else if (state.status == HomePageStatus.failure) {
              return ErrorComponentTransparent(
                message: state.errorMessage ?? 'Load Failed',
              );
            } else if (state.status == HomePageStatus.success) {
              return SetPageInfo(
                indexOfRelevantItem: 0,
                actions: [
                  IconButton(
                    onPressed: () {
                      openSearchDialog(context);
                    },
                    icon: Icon(Icons.search_rounded),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
                child: Stack(
                  children: [
                    ContentView(
                      reachedNearEnd: () {
                        context
                            .read<HomePageBloc>()
                            .add(ReachedNearEndOfScroll());
                      },
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
                      onPressedPost: (post) {
                        context.go('/home/content', extra: post);
                      },
                      posts: context.read<HomePageBloc>().state.posts!,
                      floatingHeader: false,
                      headerDelegate: _TopBarDelegate(),
                    ),
                    if (state.isLoadingMore)
                      const SafeArea(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 5,
                            child: LinearProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

// right now the header is only used to create a buffer between the very
// top post and the top of the scroll view to make it easier to see

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
