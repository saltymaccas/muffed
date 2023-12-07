import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/inbox_page/replies_screen/replies_screen.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/page.dart';

import 'mentions_screen/bloc/bloc.dart' as m;
import 'mentions_screen/mentions_screen.dart';
import 'replies_screen/bloc/bloc.dart' as r;

class InboxPage extends MPage<void> {
  const InboxPage();

  @override
  Widget build(BuildContext context) {
    return const InboxView();
  }
}

class InboxView extends StatelessWidget {
  const InboxView({super.key});

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

                      return NestedScrollView(
                        headerSliverBuilder: (context, _) {
                          return [
                            const SliverToBoxAdapter(
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
                        body: const TabBarView(
                          children: [RepliesScreen(), MentionsScreen()],
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
