import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/inbox_page/replies_screen/replies_screen.dart';
import 'package:muffed/repo/server_repo.dart';

import 'mentions_screen/bloc/bloc.dart' as m;
import 'mentions_screen/mentions_screen.dart';
import 'replies_screen/bloc/bloc.dart' as r;

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        if (!state.isLoggedIn()) {
          return Center(
            child: Text(
              'Must be logged in to access inbox',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  r.RepliesBloc(repo: context.read<ServerRepo>())
                    ..add(r.Initialize()),
            ),
            BlocProvider(
              create: (context) =>
                  m.MentionsBloc(repo: context.read<ServerRepo>())
                    ..add(m.Initialize()),
            ),
          ],
          child: Builder(
            builder: (context) {
              return BlocListener<GlobalBloc, GlobalState>(
                listenWhen: (previous, current) {
                  final LemmyAccountData? previousAccount =
                      (previous.lemmySelectedAccount == -1)
                          ? null
                          : previous
                              .lemmyAccounts[previous.lemmySelectedAccount];

                  final LemmyAccountData? currentAccount =
                      (current.lemmySelectedAccount == -1)
                          ? null
                          : current.lemmyAccounts[current.lemmySelectedAccount];

                  if (previousAccount != currentAccount ||
                      previous.lemmyDefaultHomeServer !=
                              current.lemmyDefaultHomeServer &&
                          current.lemmySelectedAccount == -1) {
                    return true;
                  }
                  return false;
                },
                listener: (context, state) {
                  context.read<r.RepliesBloc>().add(r.Initialize());
                  context.read<m.MentionsBloc>().add(m.Initialize());
                },
                child: DefaultTabController(
                  length: 2,
                  child: Builder(
                    builder: (context) {
                      final blocContext = context;

                      void toggleRead() {
                        context.read<m.MentionsBloc>().add(m.ShowAllToggled());
                        context.read<r.RepliesBloc>().add(r.ShowAllToggled());
                      }

                      return SetPageInfo(
                        indexOfRelevantItem: 1,
                        actions: [
                          BlocProvider.value(
                            value: BlocProvider.of<m.MentionsBloc>(blocContext),
                            child: BlocBuilder<m.MentionsBloc, m.MentionsState>(
                              builder: (context, state) {
                                return IconButton(
                                    visualDensity: VisualDensity.compact,
                                    isSelected: state.showAll,
                                    onPressed: toggleRead,
                                    selectedIcon: Icon(Icons.remove_red_eye),
                                    icon: Icon(Icons.remove_red_eye_outlined));
                              },
                            ),
                          ),
                        ],
                        child: NestedScrollView(
                          headerSliverBuilder: (context, _) {
                            return [
                              SliverToBoxAdapter(
                                child: SafeArea(
                                  child: TabBar(
                                    tabs: [
                                      Tab(text: 'Replies'),
                                      Tab(text: 'Mentions'),
                                    ],
                                  ),
                                ),
                              ),
                            ];
                          },
                          body: TabBarView(
                            children: [RepliesScreen(), MentionsScreen()],
                          ),
                        ),
                      );
                    },
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
