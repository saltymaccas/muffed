import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/pages/search/search_dialog.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/page.dart';
import 'package:muffed/widgets/content_scroll_view/view/content_scroll_view.dart';

class HomePage extends MPage<void> {
  const HomePage();

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
      child: const HomeView(),
    );
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
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if (state.status == HomePageStatus.initial) {
          return const SizedBox();
        }
        return Scaffold(
          body: Builder(
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

              return ContentScrollView(
                key: ValueKey(state.scrollViewConfigs[currentPage]),
                contentRetriever: state.scrollViewConfigs[currentPage],
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            state.scrollViewConfigs.length,
                            (index) => PageTab(
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
        );
      },
    );
  }
}
