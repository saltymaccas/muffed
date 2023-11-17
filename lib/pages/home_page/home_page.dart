import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/home_page/bloc/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';
import 'package:muffed/widgets/dynamic_navigation_bar/dynamic_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) {
        if (previous.getSelectedLemmyAccount() !=
            current.getSelectedLemmyAccount()) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return BlocProvider(
          create: (context) => HomePageBloc(
            scrollViews: [
              if (state.isLoggedIn())
                ContentScrollConfig(
                  title: 'Subscribed',
                  retrieveContentFunction: ({required int page}) {
                    return context.read<ServerRepo>().lemmyRepo.getPosts(
                          listingType: LemmyListingType.subscribed,
                          page: page,
                        );
                  },
                ),
              ContentScrollConfig(
                title: 'Popular',
                retrieveContentFunction: ({required int page}) {
                  return context.read<ServerRepo>().lemmyRepo.getPosts(
                        listingType: LemmyListingType.all,
                        page: page,
                      );
                },
              ),
            ],
          ),
          child: BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              return Scaffold(
                body: SetPageInfo(
                  actions: const [],
                  id: 'main_feed',
                  page: Pages.home,
                  child: ContentScrollView(
                    retrieveContent:
                        state.scrollViews[currentPage].retrieveContentFunction,
                    headerSlivers: [
                      SliverAppBar(
                        clipBehavior: Clip.hardEdge,
                        toolbarHeight: 50,
                        primary: true,
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
                                state.scrollViews.length,
                                (index) => _PageTab(
                                  name: state.scrollViews[index].title,
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
                  ),
                ),
              );
            },
          ),
        );
      },
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
