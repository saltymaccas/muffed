import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/home_page/HomePageView/home_page_view.dart';
import 'package:muffed/repo/lemmy/models.dart';

import 'package:muffed/global_state/bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) {
        if (previous.isLoggedIn() != current.isLoggedIn()) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (!state.isLoggedIn()) {
          return HomePageView(
            mode: HomePageViewMode(listingType: LemmyListingType.all),
          );
        }

        final pages = [
          HomePageView(
            key: const PageStorageKey('subscribed'),
            mode: HomePageViewMode(listingType: LemmyListingType.subscribed),
          ),
          HomePageView(
            key: const PageStorageKey('popular'),
            mode: HomePageViewMode(listingType: LemmyListingType.all),
          ),
        ];

        return NestedScrollView(
          clipBehavior: Clip.hardEdge,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                clipBehavior: Clip.hardEdge,
                expandedHeight: 43,
                toolbarHeight: 43,
                primary: true,
                floating: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                snap: true,
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _PageTab(
                          name: 'Subscribed',
                          selected: pageIndex == 0,
                          onTap: () {
                            setState(() {
                              pageIndex = 0;
                            });
                          },
                        ),
                        _PageTab(
                          name: 'Popular',
                          selected: pageIndex == 1,
                          onTap: () {
                            setState(() {
                              pageIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      height: 0.5,
                    ),
                  ],
                ),
              ),
            ];
          },
          body: pages[pageIndex],
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
