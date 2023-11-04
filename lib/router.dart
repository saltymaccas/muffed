import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/create_comment/create_comment_screen.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/pages/home_page/home_page.dart';
import 'package:muffed/pages/home_page/screens/comment_screen/comment_screen.dart';
import 'package:muffed/pages/home_page/screens/community_screen/community_screen.dart';
import 'package:muffed/pages/home_page/screens/create_post_screen/create_post_screen.dart';
import 'package:muffed/pages/home_page/screens/search/search_screen.dart';
import 'package:muffed/pages/home_page/screens/user_screen/user_screen.dart';
import 'package:muffed/pages/inbox_page/inbox_page.dart';
import 'package:muffed/pages/profile_page/profile_page.dart';
import 'package:muffed/pages/profile_page/screens/anon_settings_screen/anon_settings_screen.dart';
import 'package:muffed/pages/profile_page/screens/login_screen/login_screen.dart';
import 'package:muffed/pages/profile_page/screens/saved_posts_screen/saved_posts_screen.dart';
import 'package:muffed/pages/profile_page/screens/settings_screen/about/about.dart';
import 'package:muffed/pages/profile_page/screens/settings_screen/content_filters/content_filters.dart';
import 'package:muffed/pages/profile_page/screens/settings_screen/defaults/defaults.dart';
import 'package:muffed/pages/profile_page/screens/settings_screen/settings_screen.dart';
import 'package:muffed/pages/profile_page/screens/settings_screen/text_size/text_size.dart';
import 'package:muffed/pages/profile_page/screens/settings_screen/theme/theme.dart';
import 'package:muffed/repo/lemmy/models.dart';

extension NullNumberParsing on String? {
  int? parseInt() {
    return (this == null) ? null : int.parse(this!);
  }
}

extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}

class CreatePostRouteData {
  CreatePostRouteData({this.postToBeEdited});
  final LemmyPost? postToBeEdited;
}

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
                    Navigator.maybePop(currentContext);
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
              builder: (context, state) {
                return HomePage();
              },
              routes: [
                GoRoute(
                  path: 'content',
                  builder: (context, state) {
                    final values = (state.extra == null)
                        ? null
                        : state.extra! as (LemmyPost, BuildContext?);

                    return CommentScreen(
                      postId: state.uri.queryParameters['id'].parseInt(),
                      post: (values != null) ? values.$1 : null,
                      postItemBlocContext: (values != null) ? values.$2 : null,
                    );
                  },
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
                GoRoute(
                  path: 'community',
                  builder: (context, state) {
                    final qp = state.uri.queryParameters;

                    return CommunityScreen(
                      communityId: qp['community_id']!.parseInt(),
                    );
                  },
                ),
                GoRoute(
                  name: 'create_post',
                  path: 'create_post',
                  builder: (context, state) {
                    final qp = state.uri.queryParameters;

                    final CreatePostRouteData? data =
                        state.extra as CreatePostRouteData?;

                    return CreatePostScreen(
                      communityId: qp['community_id'].parseInt(),
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
              path: '/inbox',
              builder: (context, state) {
                return InboxPage();
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
                      },
                    ),
                    GoRoute(
                      path: 'defaults',
                      builder: (context, state) {
                        return const DefaultsSettingsPage();
                      },
                    ),
                    GoRoute(
                      path: 'text_size',
                      builder: (context, state) {
                        return const TextSizeScreen();
                      },
                    ),
                    GoRoute(
                        path: 'about',
                        builder: (context, state) {
                          return const AboutScreen();
                        }),
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
