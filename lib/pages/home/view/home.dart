import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/local_store/local_store.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/pages/search/view/search_dialog.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

class HomePage extends MPage<void> {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc()
        ..add(
          Initialise(
            isLoggedIn: context.read<LocalStore>().state.isLoggedIn,
            repo: context.read<ServerRepo>(),
          ),
        ),
      child: Builder(
        builder: (context) {
          void changeSortType(LemmySortType sortType) {
            context.read<HomePageBloc>().add(
                  SortTypeChanged(
                    pageIndex: context.read<HomePageBloc>().state.currentPage,
                    newSortType: sortType,
                  ),
                );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HomePageBloc>().add(
                  PageChanged(
                    newPageIndex:
                        context.read<HomePageBloc>().state.currentPage,
                  ),
                );
          });
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            pageActions.setActions([
              IconButton(
                onPressed: () {
                  openSearchDialog(context);
                },
                icon: const Icon(Icons.search_rounded),
                visualDensity: VisualDensity.compact,
              ),
              BlocBuilder<HomePageBloc, HomePageState>(
                bloc: context.read<HomePageBloc>(),
                builder: (context, state) {
                  return MuffedPopupMenuButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.sort),
                    selectedValue: state.currentScrollViewConfig?.sortType,
                    items: [
                      MuffedPopupMenuItem(
                        title: 'Hot',
                        icon: const Icon(Icons.local_fire_department),
                        value: LemmySortType.hot,
                        onTap: () => changeSortType(LemmySortType.hot),
                      ),
                      MuffedPopupMenuItem(
                        title: 'Active',
                        icon: const Icon(Icons.rocket_launch),
                        value: LemmySortType.active,
                        onTap: () => changeSortType(LemmySortType.active),
                      ),
                      MuffedPopupMenuItem(
                        title: 'New',
                        icon: const Icon(Icons.auto_awesome),
                        value: LemmySortType.latest,
                        onTap: () => changeSortType(LemmySortType.latest),
                      ),
                      MuffedPopupMenuExpandableItem(
                        title: 'Top',
                        items: [
                          MuffedPopupMenuItem(
                            title: 'All Time',
                            icon: const Icon(Icons.military_tech),
                            value: LemmySortType.topAll,
                            onTap: () => changeSortType(LemmySortType.topAll),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Year',
                            icon: const Icon(Icons.calendar_today),
                            value: LemmySortType.topYear,
                            onTap: () => changeSortType(LemmySortType.topYear),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Month',
                            icon: const Icon(Icons.calendar_month),
                            value: LemmySortType.topMonth,
                            onTap: () => changeSortType(LemmySortType.topMonth),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Week',
                            icon: const Icon(Icons.view_week),
                            value: LemmySortType.topWeek,
                            onTap: () => changeSortType(LemmySortType.topWeek),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Day',
                            icon: const Icon(Icons.view_day),
                            value: LemmySortType.topDay,
                            onTap: () => changeSortType(LemmySortType.topDay),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Twelve Hours',
                            icon: const Icon(Icons.schedule),
                            value: LemmySortType.topTwelveHour,
                            onTap: () =>
                                changeSortType(LemmySortType.topTwelveHour),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Six Hours',
                            icon: const Icon(Icons.view_module_outlined),
                            value: LemmySortType.topSixHour,
                            onTap: () =>
                                changeSortType(LemmySortType.topSixHour),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Hour',
                            icon: const Icon(Icons.hourglass_bottom),
                            value: LemmySortType.topHour,
                            onTap: () => changeSortType(LemmySortType.topHour),
                          ),
                        ],
                      ),
                      MuffedPopupMenuExpandableItem(
                        title: 'Comments',
                        items: [
                          MuffedPopupMenuItem(
                            title: 'Most Comments',
                            icon: const Icon(Icons.comment_bank),
                            value: LemmySortType.mostComments,
                            onTap: () =>
                                changeSortType(LemmySortType.mostComments),
                          ),
                          MuffedPopupMenuItem(
                            title: 'New Comments',
                            icon: const Icon(Icons.add_comment),
                            value: LemmySortType.newComments,
                            onTap: () =>
                                changeSortType(LemmySortType.newComments),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ]);
          });

          return BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              return BlocProvider(
                key: ValueKey(state.currentPage),
                create: (context) => ContentScrollBloc<LemmyPost>(
                  contentRetriever: context
                      .read<HomePageBloc>()
                      .state
                      .currentScrollViewConfig!,
                )..add(LoadInitialItems()),
                child: Builder(
                  builder: (context) {
                    return MultiBlocListener(
                      listeners: [
                        BlocListener<LocalStore, GlobalState>(
                          listenWhen: (previous, current) {
                            return previous.currentLemmyEndPointIdentifyer !=
                                current.currentLemmyEndPointIdentifyer;
                          },
                          listener: (context, state) {
                            context.read<HomePageBloc>().add(
                                  Initialise(
                                    isLoggedIn: state.isLoggedIn,
                                    repo: context.read<ServerRepo>(),
                                  ),
                                );
                            context
                                .read<ContentScrollBloc<LemmyPost>>()
                                .add(LoadInitialItems());
                          },
                        ),
                        BlocListener<HomePageBloc, HomePageState>(
                          listener: (context, state) {
                            final scrollBloc =
                                context.read<ContentScrollBloc<LemmyPost>>();

                            scrollBloc.add(
                              RetrieveContentDelegateChanged(
                                (scrollBloc.state.contentDelegate
                                        as LemmyPostRetriever)
                                    .copyWith(
                                  sortType:
                                      state.currentScrollViewConfig!.sortType,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      child: const _HomeView(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if (state.status == HomePageStatus.initial) {
          return const SizedBox();
        }
        return Scaffold(
          body: ContentScrollView<LemmyPost>(
            builderDelegate: LemmyPostContentBuilderDelegate(),
            headerSlivers: [
              SliverAppBar(
                clipBehavior: Clip.hardEdge,
                toolbarHeight: 50,
                floating: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                snap: true,
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Row(
                      children: List.generate(
                        state.scrollViewConfigs.length,
                        (index) => PageTab(
                          onTap: () {
                            context
                                .read<HomePageBloc>()
                                .add(PageChanged(newPageIndex: index));
                          },
                          name: state.scrollViewConfigs[index].title,
                          selected: index == state.currentPage,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
