import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/view/pages/anon_settings/anon_settings_screen.dart';
import 'package:muffed/view/pages/community_screen/community_screen.dart';
import 'package:muffed/view/pages/create_post_screen/create_post_screen.dart';
import 'package:muffed/view/pages/home_page/home_page.dart';
import 'package:muffed/view/pages/inbox_page/inbox_page.dart';
import 'package:muffed/view/pages/login/login_screen.dart';
import 'package:muffed/view/pages/post_screen/post_screen.dart';
import 'package:muffed/view/pages/profile_page/profile_page.dart';
import 'package:muffed/view/pages/saved_posts/saved_posts_screen.dart';
import 'package:muffed/view/pages/search/search_screen.dart';
import 'package:muffed/view/pages/settings/about/about.dart';
import 'package:muffed/view/pages/settings/content_filters/content_filters.dart';
import 'package:muffed/view/pages/settings/defaults/defaults.dart';
import 'package:muffed/view/pages/settings/look/look.dart';
import 'package:muffed/view/pages/settings/settings_screen.dart';
import 'package:muffed/view/pages/user_screen/user_screen.dart';
import 'package:muffed/view/widgets/create_comment/create_comment_screen.dart';
import 'package:muffed/view/widgets/dynamic_navigation_bar/dynamic_navigation_bar.dart';

extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}

abstract class MuffedTypedRoute extends GoRoute {
  MuffedTypedRoute({
    required super.path,
    required super.name,
    super.routes,
    super.builder,
  });
}

class CreatePostRouteData {
  CreatePostRouteData({this.postToBeEdited});

  final LemmyPost? postToBeEdited;
}

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
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
                    Navigator.maybePop(currentContext);
                  }
                }
              } else {
                context
                    .read<DynamicNavigationBarBloc>()
                    .add(GoneToNewMainPage(index));

                navigationShell.goBranch(
                  index,
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
              name: 'home',
              path: '/home',
              builder: (context, state) {
                return const HomePage();
              },
              routes: [
                PostScreenRouteDefinition(
                  routes: [
                    GoRoute(
                      path: 'create_comment',
                      builder: (context, state) {
                        return CreateCommentScreen(
                          postId:
                              int.parse(state.uri.queryParameters['postId']!),
                          parentId: (state
                                      .uri.queryParameters['parentCommentId'] !=
                                  null)
                              ? int.parse(
                                  state.uri.queryParameters['parentCommentId']!,
                                )
                              : null,
                          initialValue:
                              state.uri.queryParameters['initialValue'],
                        );
                      },
                    ),
                  ],
                ),
                CommunityScreenRouterDefinition(),
                GoRoute(
                  name: 'create_post',
                  path: 'create_post',
                  builder: (context, state) {
                    final qp = state.uri.queryParameters;

                    final CreatePostRouteData? data =
                        state.extra as CreatePostRouteData?;

                    return CreatePostScreen(
                      communityId: qp['community_id']?.parseInt(),
                      postBeingEdited: data?.postToBeEdited,
                    );
                  },
                ),
                GoRoute(
                  path: 'search',
                  builder: (context, state) {
                    return SearchScreen(
                      searchQuery: state.uri.queryParameters['query'],
                      communityId:
                          state.uri.queryParameters['community_id'] != null
                              ? int.parse(
                                  state.uri.queryParameters['community_id']!,
                                )
                              : null,
                      communityName:
                          state.uri.queryParameters['community_name'],
                      //initialState: state.extra as SearchState?,
                    );
                  },
                ),
                GoRoute(
                  name: 'person',
                  path: 'person',
                  builder: (context, state) {
                    final qp = state.uri.queryParameters;

                    return UserScreen(
                      userId: (qp['id'] != null) ? int.parse(qp['id']!) : null,
                      username: qp['username'],
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
              path: '/messages',
              builder: (context, state) {
                return const Placeholder();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/inbox',
              builder: (context, state) {
                return const InboxPage();
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
                    return const LoginPage();
                  },
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) {
                    return const SettingsPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'look',
                      builder: (context, state) {
                        return const SettingsLookPage();
                      },
                    ),
                    GoRoute(
                      path: 'contentfilters',
                      builder: (context, state) {
                        return const ContentFiltersPage();
                      },
                    ),
                    GoRoute(
                      path: 'defaults',
                      builder: (context, state) {
                        return const DefaultsSettingsPage();
                      },
                    ),
                    GoRoute(
                      path: 'about',
                      builder: (context, state) {
                        return const AboutScreen();
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
                GoRoute(
                  path: 'anon_account_settings',
                  builder: (context, state) {
                    return const AnonSettingsScreen();
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
