import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/widgets/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

import '../../widgets/page.dart';
import '../search/search_dialog.dart';
import 'bloc/bloc.dart';

class HomePage extends MPage<void> {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc()
        ..add(
          Initialise(
            isLoggedIn: context.read<GlobalBloc>().isLoggedIn(),
            repo: context.read<ServerRepo>(),
          ),
        ),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<HomePageBloc>(context);

          if (state.status == HomePageStatus.initial) {
            return const SizedBox();
          }

          return BlocListener<GlobalBloc, GlobalState>(
            listenWhen: (previous, current) {
              if (previous.getSelectedLemmyAccount() !=
                  current.getSelectedLemmyAccount()) {
                return true;
              }

              return false;
            },
            listener: (context, state) {
              context.read<HomePageBloc>().add(
                    Initialise(
                      isLoggedIn: context.read<GlobalBloc>().isLoggedIn(),
                      repo: context.read<ServerRepo>(),
                    ),
                  );
            },
            child: Scaffold(
              body: SetPageInfo(
                actions: const [],
                id: 'main_feed',
                page: Pages.home,
                child: Builder(
                  builder: (context) {
                    final allPageActions = [
                      IconButton(
                        onPressed: () {
                          openSearchDialog(context);
                        },
                        icon: const Icon(Icons.search_rounded),
                        visualDensity: VisualDensity.compact,
                      ),
                    ];

                    context.read<DynamicNavigationBarBloc>().add(
                          EditPageActions(
                            context: context,
                            page: Pages.home,
                            actions: [
                              ...allPageActions,
                              if (state.scrollViewConfigs[currentPage]
                                  is LemmyPostGetter) ...[
                                BlocProvider.value(
                                  value: bloc,
                                  child:
                                      BlocBuilder<HomePageBloc, HomePageState>(
                                    builder: (context, state) {
                                      final bloc = context.read<HomePageBloc>();

                                      return MuffedPopupMenuButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.sort),
                                        selectedValue: (state.scrollViewConfigs[
                                                currentPage] as LemmyPostGetter)
                                            .sortType,
                                        items: [
                                          MuffedPopupMenuItem(
                                            title: 'Hot',
                                            icon: const Icon(
                                              Icons.local_fire_department,
                                            ),
                                            value: LemmySortType.hot,
                                            onTap: () => bloc.add(
                                              SortTypeChanged(
                                                pageIndex: currentPage,
                                                newSortType: LemmySortType.hot,
                                              ),
                                            ),
                                          ),
                                          MuffedPopupMenuItem(
                                            title: 'Active',
                                            icon:
                                                const Icon(Icons.rocket_launch),
                                            value: LemmySortType.active,
                                            onTap: () => bloc.add(
                                              SortTypeChanged(
                                                pageIndex: currentPage,
                                                newSortType:
                                                    LemmySortType.active,
                                              ),
                                            ),
                                          ),
                                          MuffedPopupMenuItem(
                                            title: 'New',
                                            icon:
                                                const Icon(Icons.auto_awesome),
                                            value: LemmySortType.latest,
                                            onTap: () => bloc.add(
                                              SortTypeChanged(
                                                pageIndex: currentPage,
                                                newSortType:
                                                    LemmySortType.latest,
                                              ),
                                            ),
                                          ),
                                          MuffedPopupMenuExpandableItem(
                                            title: 'Top',
                                            items: [
                                              MuffedPopupMenuItem(
                                                title: 'All Time',
                                                icon: const Icon(
                                                    Icons.military_tech),
                                                value: LemmySortType.topAll,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType:
                                                        LemmySortType.topAll,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Year',
                                                icon: const Icon(
                                                    Icons.calendar_today),
                                                value: LemmySortType.topYear,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType:
                                                        LemmySortType.topYear,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Month',
                                                icon: const Icon(
                                                    Icons.calendar_month),
                                                value: LemmySortType.topMonth,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType:
                                                        LemmySortType.topMonth,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Week',
                                                icon:
                                                    const Icon(Icons.view_week),
                                                value: LemmySortType.topWeek,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType:
                                                        LemmySortType.topWeek,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Day',
                                                icon:
                                                    const Icon(Icons.view_day),
                                                value: LemmySortType.topDay,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType:
                                                        LemmySortType.topDay,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Twelve Hours',
                                                icon:
                                                    const Icon(Icons.schedule),
                                                value:
                                                    LemmySortType.topTwelveHour,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType: LemmySortType
                                                        .topTwelveHour,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Six Hours',
                                                icon: const Icon(
                                                  Icons.view_module_outlined,
                                                ),
                                                value: LemmySortType.topSixHour,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType: LemmySortType
                                                        .topSixHour,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'Hour',
                                                icon: const Icon(
                                                  Icons.hourglass_bottom,
                                                ),
                                                value: LemmySortType.topHour,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType:
                                                        LemmySortType.topHour,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          MuffedPopupMenuExpandableItem(
                                            title: 'Comments',
                                            items: [
                                              MuffedPopupMenuItem(
                                                title: 'Most Comments',
                                                icon: const Icon(
                                                    Icons.comment_bank),
                                                value:
                                                    LemmySortType.mostComments,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType: LemmySortType
                                                        .mostComments,
                                                  ),
                                                ),
                                              ),
                                              MuffedPopupMenuItem(
                                                title: 'New Comments',
                                                icon: const Icon(
                                                    Icons.add_comment),
                                                value:
                                                    LemmySortType.newComments,
                                                onTap: () => bloc.add(
                                                  SortTypeChanged(
                                                    pageIndex: currentPage,
                                                    newSortType: LemmySortType
                                                        .newComments,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                            id: 'main_feed',
                          ),
                        );

                    return ContentScrollView(
                      key: ValueKey(state.scrollViewConfigs[currentPage]),
                      contentRetriever: state.scrollViewConfigs[currentPage],
                      headerSlivers: [
                        SliverAppBar(
                          clipBehavior: Clip.hardEdge,
                          toolbarHeight: 50,
                          floating: true,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          foregroundColor:
                              Theme.of(context).colorScheme.background,
                          surfaceTintColor:
                              Theme.of(context).colorScheme.background,
                          snap: true,
                          flexibleSpace: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  state.scrollViewConfigs.length,
                                  (index) => _PageTab(
                                    onTap: () {
                                      setState(() {
                                        currentPage = index;
                                      });
                                    },
                                    name: state.scrollViewConfigs[index].title,
                                    selected: index == currentPage,
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
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageTab extends StatelessWidget {
  const _PageTab({
    required this.name,
    required this.selected,
    this.onTap,
  });

  final String name;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: selected
            ? Theme.of(context).colorScheme.inverseSurface
            : Theme.of(context).colorScheme.surfaceVariant,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: InkWell(
          splashColor: !selected
              ? Theme.of(context).colorScheme.inverseSurface
              : Theme.of(context).colorScheme.surfaceVariant,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Text(
              name,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: selected
                        ? Theme.of(context).colorScheme.onInverseSurface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
