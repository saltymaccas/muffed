import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:muffed/community_screen/community_screen.dart';
import 'package:muffed/comment_screen/comment_screen.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/home_page/home_page.dart';
import 'package:muffed/inbox_page/inbox_page.dart';
import 'package:muffed/profile_page/login_page/login_page.dart';
import 'package:muffed/profile_page/profile_page.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:path_provider/path_provider.dart';

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
          bottomNavigationBar:
              DynamicNavigationBar(onItemTapped: (index, currentContext) {
            if (index == navigationShell.currentIndex) {
              if (currentContext != null) {
                if (currentContext.canPop()) {
                  Navigator.pop(currentContext);
                }
              }
            } else {
              context
                  .read<DynamicNavigationBarBloc>()
                  .add(GoneToNewMainPage(index));

              navigationShell.goBranch(
                index,
                initialLocation: false,
              );
            }
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
                    return CommentScreen(state.extra as LemmyPost);
                  },
                ),
                GoRoute(
                  path: 'community',
                  builder: (context, state) {
                    return CommunityScreen(
                        communityId: int.parse(state.queryParameters['id']!));
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/inbox',
              pageBuilder: (context, state) {
                return const MaterialPage(child: InboxPage());
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
              routes: [
                GoRoute(
                  path: 'login',
                  builder: (context, state) {
                    return LoginPage();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

Future<void> main() async {
  // initialize hydrated bloc
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DynamicNavigationBarBloc()),
          BlocProvider(create: (context) => GlobalBloc()),
        ],
        child: Builder(builder: (context) {
          return RepositoryProvider(
            create: (context) => ServerRepo(context.read<GlobalBloc>()),
            child: MaterialApp.router(
              routerConfig: _router,
              title: 'Muffed',
              theme: ThemeData(
                colorScheme: lightDynamic,
                useMaterial3: true,
              ),
              darkTheme:
                  ThemeData(colorScheme: darkDynamic, useMaterial3: true),
              themeMode: ThemeMode.system,
            ),
          );
        }),
      );
    });
  }
}
