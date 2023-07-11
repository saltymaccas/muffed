import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/home_page/home_page.dart';
import 'package:muffed/inbox_page/inbox_page.dart';
import 'package:muffed/profile_page/profile_page.dart';
import 'package:muffed/new_post_page/new_post_page.dart';
import 'package:muffed/home_page/content_screen/content_screen.dart';
import 'package:muffed/repo/server_repo.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: <String, int>{
                  '/home': 0,
                  '/inbox': 1,
                  '/newPost': 2,
                  '/profile': 3,
                }[GoRouter.of(context)
                    .routeInformationProvider
                    .value
                    .location] ??
                0,
            onDestinationSelected: (int index) {
              switch (index) {
                case 0:
                  context.go('/home');
                case 1:
                  context.go('/inbox');
                case 2:
                  context.go('/newPost');
                case 3:
                  context.go('/profile');
              }
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
              NavigationDestination(icon: Icon(Icons.add), label: 'New Post'),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage();
                },
                routes: [
                  GoRoute(
                    name: 'contentScreen',
                    path: 'content',
                    pageBuilder: (context, state) => MaterialPage(
                        child: ContentScreen(state.extra as LemmyPost)),
                  )
                ])
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/inbox',
              builder: (BuildContext context, GoRouterState state) {
                return const InboxPage();
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
      );
    });
  }
}
