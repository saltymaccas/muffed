import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/pages/home_page/home_page.dart';
import 'package:muffed/pages/inbox_page/inbox_page.dart';
import 'package:muffed/pages/profile_page/login_page/login_page.dart';
import 'package:muffed/pages/profile_page/profile_page.dart';
import 'package:muffed/repo/lemmy/models.dart';
import 'package:muffed/screens/comment_screen/comment_screen.dart';
import 'package:muffed/screens/community_screen/community_screen.dart';
import 'package:muffed/screens/saved_posts_screen/saved_posts_screen.dart';
import 'package:muffed/screens/search/search_screen.dart';
import 'package:muffed/screens/settings_screen/content_filters/content_filters.dart';
import 'package:muffed/screens/settings_screen/defaults/defaults.dart';
import 'package:muffed/screens/settings_screen/settings_screen.dart';
import 'package:muffed/screens/settings_screen/theme/theme.dart';
import 'package:muffed/screens/user_screen/user_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      // navigatorContainerBuilder: (
      //   BuildContext context,
      //   StatefulNavigationShell navigationShell,
      //   List<Widget> children,
      // ) {
      //   final List<Widget> stackItems = [];
      //
      //   for (int i = 0; i < children.length; i++) {
      //     stackItems.add(
      //       Offstage(
      //         offstage: navigationShell.currentIndex != i,
      //         child: children[i],
      //       ),
      //     );
      //   }
      //
      //   return IndexedStack(
      //     index: navigationShell.currentIndex,
      //     children: stackItems,
      //   );
      // },
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        context
            .read<DynamicNavigationBarBloc>()
            .add(GoneToNewMainPage(navigationShell.currentIndex));

        return Scaffold(
          bottomNavigationBar: DynamicNavigationBar(
            onItemTapped: (index, currentContext) {
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
            },
          ),
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
                    final values = state.extra! as (LemmyPost, BuildContext);

                    return CommentScreen(
                      post: values.$1,
                      postItemBlocContext: values.$2,
                    );
                  },
                ),
                GoRoute(
                  path: 'community',
                  builder: (context, state) {
                    return CommunityScreen(
                      communityId: int.parse(state.uri.queryParameters['id']!),
                    );
                  },
                ),
                GoRoute(
                  path: 'search',
                  builder: (context, state) {
                    return SearchScreen(
                      searchQuery: state.uri.queryParameters['query'],
                      //initialState: state.extra as SearchState?,
                    );
                  },
                ),
                GoRoute(
                  path: 'person',
                  builder: (context, state) {
                    return UserScreen(
                      userId: (state.uri.queryParameters['id'] != null)
                          ? int.parse(state.uri.queryParameters['id']!)
                          : null,
                      username: state.uri.queryParameters['username'],
                    );
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
            ),
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
                GoRoute(
                  path: 'settings',
                  builder: (context, state) {
                    return SettingsPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'look',
                      builder: (context, state) {
                        return const SettingsThemePage();
                      },
                    ),
                    GoRoute(
                        path: 'contentfilters',
                        builder: (context, state) {
                          return const ContentFiltersPage();
                        }),
                    GoRoute(
                      path: 'defaults',
                      builder: (context, state) {
                        return const DefaultsSettingsPage();
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'saved_posts',
                  builder: (context, state) {
                    return const SavedPostsScreen();
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
