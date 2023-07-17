import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/home_page/home_page.dart';
import 'package:muffed/inbox_page/inbox_page.dart';
import 'package:muffed/profile_page/profile_page.dart';
import 'package:muffed/new_post_page/new_post_page.dart';
import 'package:muffed/home_page/content_screen/content_screen.dart';
import 'package:muffed/repo/server_repo.dart';
import 'dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'dynamic_navigation_bar/bloc/bloc.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      restorationScopeId: 'indexStack',
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return Scaffold(
          bottomNavigationBar: DynamicNavigationBar(onTap: (index) {

            context
                .read<DynamicNavigationBarBloc>()
                .add(GoneToNewMainPage(index));

            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          }),
          body: navigationShell,
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                path: '/home',
                pageBuilder: (context, state) {
                  return MaterialPage(child: HomePage());
                },
                routes: [
                  GoRoute(
                      path: 'content',
                      builder: (context, state) {
                        return ContentScreen(state.extra as LemmyPost);
                      }),
                ]),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/inbox',
              pageBuilder: (context, state) {
                context
                    .read<DynamicNavigationBarBloc>()
                    .add(GoneToNewMainPage(1));
                return const MaterialPage(child: InboxPage());
              },
            )
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/newPost',
              builder: (BuildContext context, GoRouterState state) {
                return const NewPostPage();
              },
            )
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (BuildContext context, GoRouterState state) {
                return const ProfilePage();
              },
            )
          ],
        ),
      ],
    ),
  ],
);

class _BottomAppBar extends StatefulWidget {
  const _BottomAppBar({super.key});

  @override
  State<_BottomAppBar> createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<_BottomAppBar>
    with SingleTickerProviderStateMixin {
  String currentPage = '/home';

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 1.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router =
        GoRouter.of(context).routeInformationProvider.addListener(() {
      String _page =
          GoRouter.of(context).routeInformationProvider.value.uri.toString();

      print(_page);

      if (_controller.status == AnimationStatus.completed ||
          _controller.status == AnimationStatus.forward &&
              _page.contains('/home')) {
        _controller.forward(from: 1);
      }
    });

    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedContainer(
              clipBehavior: Clip.hardEdge,
              duration: Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    visualDensity: VisualDensity.compact,
                    iconSize: 24,
                    padding: EdgeInsets.all(10),
                    color: Theme.of(context).colorScheme.onSurface,
                    focusColor: Theme.of(context).colorScheme.onSurface,
                    isSelected: GoRouter.of(context)
                            .routeInformationProvider
                            .value
                            .uri ==
                        Uri.parse('/home'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: 10,
                      width: 2,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                    visualDensity: VisualDensity.compact,
                    iconSize: 24,
                    padding: EdgeInsets.all(10),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.sort),
                    visualDensity: VisualDensity.compact,
                    iconSize: 24,
                    padding: EdgeInsets.all(10),
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert),
                      visualDensity: VisualDensity.compact,
                      iconSize: 24,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/inbox');
              },
              icon: Icon(Icons.inbox_outlined),
              selectedIcon: Icon(Icons.inbox),
              visualDensity: VisualDensity.compact,
              iconSize: 24,
              padding: EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.onSurface,
              focusColor: Theme.of(context).colorScheme.onSurface,
              isSelected:
                  GoRouter.of(context).routeInformationProvider.value.uri ==
                      Uri.parse('/inbox'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return RepositoryProvider(
        create: (context) => ServerRepo(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DynamicNavigationBarBloc())
          ],
          child: MaterialApp.router(
            routerConfig: _router,
            title: 'Muffed',
            theme: ThemeData(
              colorScheme: lightDynamic,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(colorScheme: darkDynamic, useMaterial3: true),
            themeMode: ThemeMode.system,
          ),
        ),
      );
    });
  }
}
