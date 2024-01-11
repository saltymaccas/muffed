import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/components/paged_content.dart/paged_content.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/interfaces/lemmy/models/models.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/widgets/lemmy_post_scroll/bloc/bloc.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';
import 'package:muffed/widgets/exception_snackbar.dart';
import 'package:muffed/widgets/lem_sort_menu_button.dart';
import 'package:muffed/widgets/lemmy_post_scroll/view/view.dart';
import 'package:muffed/widgets/post/post.dart';

class HomePage extends MPage<void> {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return _HomePage(
          pageActions: pageActions,
        );
      },
    );
  }
}

final class TabModel extends Equatable {
  const TabModel(this.title, this.view);

  final String title;
  final Widget view;

  @override
  List<Object?> get props => [title, view];
}

class _HomePage extends StatefulWidget {
  const _HomePage({required this.pageActions, super.key});

  final PageActions pageActions;

  @override
  State<_HomePage> createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  int selectedTabIndex = 0;

  late bool authenticated;

  @override
  void initState() {
    super.initState();
    authenticated = context.db.state.auth.lemmy.loggedIn;
    context.db.stream.listen((event) {
      if (event.auth.lemmy.loggedIn != authenticated) {
        setState(() {
          authenticated = event.auth.lemmy.loggedIn;
        });
      }
    });

    selectedTabIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      if (authenticated)
        TabModel(
            'Subscribed',
            _LemmyPostScrollTabView(
              listingType: ListingType.subscribed,
            )),
      TabModel(
          'Popular',
          _LemmyPostScrollTabView(
            listingType: ListingType.all,
          )),
      TabModel(
          'Local',
          _LemmyPostScrollTabView(
            listingType: ListingType.local,
          ))
    ];
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          clipBehavior: Clip.hardEdge,
          toolbarHeight: 50,
          floating: true,
          snap: true,
          flexibleSpace: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Row(
                children: List.generate(
                  tabs.length,
                  (index) => PageTab(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    name: tabs[index].title,
                    selected: index == selectedTabIndex,
                  ),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          child: tabs[selectedTabIndex].view,
        ),
      ],
    );
  }
}

class _LemmyPostScrollTabView extends StatefulWidget {
  const _LemmyPostScrollTabView({required this.listingType, super.key});

  final ListingType listingType;

  @override
  State<_LemmyPostScrollTabView> createState() =>
      _LemmyPostScrollTabViewState();
}

class _LemmyPostScrollTabViewState extends State<_LemmyPostScrollTabView> {
  late ListingType type;
  late final PostPagedScrollBloc postScrollBloc;

  @override
  void initState() {
    super.initState();

    type = widget.listingType;
    postScrollBloc = PostPagedScrollBloc(
      LemmyClient(context),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PageActions>().setActions(
        [
          BlocBuilder<PostPagedScrollBloc, PagedContentState>(
            bloc: postScrollBloc,
            builder: (context, state) {
              return LemSortMenuButton(
                selectedValue: state.loadingState != null
                    ? state.loadingState!.query.sort
                    : state.loadedState!.query.sort,
                onChanged: (newSort) => postScrollBloc.add(
                  LoadNewQueryRequested(
                    state.loadedState!.query.copyWith(sort: newSort),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  @override
  void didUpdateWidget(covariant _LemmyPostScrollTabView oldWidget) {
    if (oldWidget != widget) {
      type = widget.listingType;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}








//     return BlocProvider(
//       create: (context) => HomePageBloc()
//         ..add(
//           Initialise(
//             isLoggedIn: context.db.state.auth.lemmy.loggedIn,
//             repo: context.read<ServerRepo>(),
//           ),
//         ),
//       child: Builder(
//         builder: (context) {
//           void changeSortType(LemmySortType sortType) {
//             context.read<HomePageBloc>().add(
//                   SortTypeChanged(
//                     pageIndex: context.read<HomePageBloc>().state.currentPage,
//                     newSortType: sortType,
//                   ),
//                 );
//           }

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             context.read<HomePageBloc>().add(
//                   PageChanged(
//                     newPageIndex:
//                         context.read<HomePageBloc>().state.currentPage,
//                   ),
//                 );
//           });
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             pageActions.setActions([
//               IconButton(
//                 onPressed: () {
//                   openSearchDialog(context);
//                 },
//                 icon: const Icon(Icons.search_rounded),
//                 visualDensity: VisualDensity.compact,
//               ),
//               BlocBuilder<HomePageBloc, HomePageState>(
//                 bloc: context.read<HomePageBloc>(),
//                 builder: (context, state) {
//                   return MuffedPopupMenuButton(
//                     visualDensity: VisualDensity.compact,
//                     icon: const Icon(Icons.sort),
//                     selectedValue: state.currentScrollViewConfig?.sortType,
//                     items: [
//                       MuffedPopupMenuItem(
//                         title: 'Hot',
//                         icon: const Icon(Icons.local_fire_department),
//                         value: LemmySortType.hot,
//                         onTap: () => changeSortType(LemmySortType.hot),
//                       ),
//                       MuffedPopupMenuItem(
//                         title: 'Active',
//                         icon: const Icon(Icons.rocket_launch),
//                         value: LemmySortType.active,
//                         onTap: () => changeSortType(LemmySortType.active),
//                       ),
//                       MuffedPopupMenuItem(
//                         title: 'New',
//                         icon: const Icon(Icons.auto_awesome),
//                         value: LemmySortType.latest,
//                         onTap: () => changeSortType(LemmySortType.latest),
//                       ),
//                       MuffedPopupMenuExpandableItem(
//                         title: 'Top',
//                         items: [
//                           MuffedPopupMenuItem(
//                             title: 'All Time',
//                             icon: const Icon(Icons.military_tech),
//                             value: LemmySortType.topAll,
//                             onTap: () => changeSortType(LemmySortType.topAll),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Year',
//                             icon: const Icon(Icons.calendar_today),
//                             value: LemmySortType.topYear,
//                             onTap: () => changeSortType(LemmySortType.topYear),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Month',
//                             icon: const Icon(Icons.calendar_month),
//                             value: LemmySortType.topMonth,
//                             onTap: () => changeSortType(LemmySortType.topMonth),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Week',
//                             icon: const Icon(Icons.view_week),
//                             value: LemmySortType.topWeek,
//                             onTap: () => changeSortType(LemmySortType.topWeek),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Day',
//                             icon: const Icon(Icons.view_day),
//                             value: LemmySortType.topDay,
//                             onTap: () => changeSortType(LemmySortType.topDay),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Twelve Hours',
//                             icon: const Icon(Icons.schedule),
//                             value: LemmySortType.topTwelveHour,
//                             onTap: () =>
//                                 changeSortType(LemmySortType.topTwelveHour),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Six Hours',
//                             icon: const Icon(Icons.view_module_outlined),
//                             value: LemmySortType.topSixHour,
//                             onTap: () =>
//                                 changeSortType(LemmySortType.topSixHour),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'Hour',
//                             icon: const Icon(Icons.hourglass_bottom),
//                             value: LemmySortType.topHour,
//                             onTap: () => changeSortType(LemmySortType.topHour),
//                           ),
//                         ],
//                       ),
//                       MuffedPopupMenuExpandableItem(
//                         title: 'Comments',
//                         items: [
//                           MuffedPopupMenuItem(
//                             title: 'Most Comments',
//                             icon: const Icon(Icons.comment_bank),
//                             value: LemmySortType.mostComments,
//                             onTap: () =>
//                                 changeSortType(LemmySortType.mostComments),
//                           ),
//                           MuffedPopupMenuItem(
//                             title: 'New Comments',
//                             icon: const Icon(Icons.add_comment),
//                             value: LemmySortType.newComments,
//                             onTap: () =>
//                                 changeSortType(LemmySortType.newComments),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ]);
//           });

//           return BlocBuilder<HomePageBloc, HomePageState>(
//             builder: (context, state) {
//               return BlocProvider(
//                 key: ValueKey(state.currentPage),
//                 create: (context) => ContentScrollBloc<LemmyPost>(
//                   contentRetriever: context
//                       .read<HomePageBloc>()
//                       .state
//                       .currentScrollViewConfig!,
//                 )..add(LoadInitialItems()),
//                 child: Builder(
//                   builder: (context) {
//                     return MultiBlocListener(
//                       listeners: [
//                         BlocListener<DB, DBModel>(
//                           listenWhen: (previous, current) {
//                             return false;
//                             // TODO:
//                             // return previous.currentLemmyEndPointIdentifyer !=
//                             //     current.currentLemmyEndPointIdentifyer;
//                           },
//                           listener: (context, state) {
//                             context.read<HomePageBloc>().add(
//                                   Initialise(
//                                     isLoggedIn: state.auth.lemmy.loggedIn,
//                                     repo: context.read<ServerRepo>(),
//                                   ),
//                                 );
//                             context
//                                 .read<ContentScrollBloc<LemmyPost>>()
//                                 .add(LoadInitialItems());
//                           },
//                         ),
//                         BlocListener<HomePageBloc, HomePageState>(
//                           listener: (context, state) {
//                             final scrollBloc =
//                                 context.read<ContentScrollBloc<LemmyPost>>();

//                             scrollBloc.add(
//                               RetrieveContentDelegateChanged(
//                                 (scrollBloc.state.contentDelegate
//                                         as LemmyPostRetriever)
//                                     .copyWith(
//                                   sortType:
//                                       state.currentScrollViewConfig!.sortType,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                       child: const _HomeView(),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class _HomeView extends StatelessWidget {
//   const _HomeView();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomePageBloc, HomePageState>(
//       builder: (context, state) {
//         if (state.status == HomePageStatus.initial) {
//           return const SizedBox();
//         }
//         return Scaffold(
//           body: ContentScrollView<LemmyPost>(
//             builderDelegate: LemmyPostContentBuilderDelegate(),
//             headerSlivers: [
//               SliverAppBar(
//                 clipBehavior: Clip.hardEdge,
//                 toolbarHeight: 50,
//                 floating: true,
//                 backgroundColor: Theme.of(context).colorScheme.background,
//                 foregroundColor: Theme.of(context).colorScheme.background,
//                 surfaceTintColor: Theme.of(context).colorScheme.background,
//                 snap: true,
//                 flexibleSpace: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).padding.top,
//                     ),
//                     Row(
//                       children: List.generate(
//                         state.scrollViewConfigs.length,
//                         (index) => PageTab(
//                           onTap: () {
//                             context
//                                 .read<HomePageBloc>()
//                                 .add(PageChanged(newPageIndex: index));
//                           },
//                           name: state.scrollViewConfigs[index].title,
//                           selected: index == state.currentPage,
//                         ),
//                       ),
//                     ),
//                     const Divider(
//                       height: 0.5,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
