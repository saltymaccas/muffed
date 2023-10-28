import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/dynamic_navigation_bar/dynamic_navigation_bar.dart';
import 'package:muffed/pages/inbox_page/replies_screen/replies_screen.dart';
import 'package:muffed/repo/server_repo.dart';

import 'mentions_screen/bloc/bloc.dart' as mentions;
import 'mentions_screen/mentions_screen.dart';
import 'replies_screen/bloc/bloc.dart' as replies;

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              replies.RepliesBloc(repo: context.read<ServerRepo>())
                ..add(replies.Initialize()),
        ),
        BlocProvider(
          create: (context) =>
              mentions.MentionsBloc(repo: context.read<ServerRepo>())
                ..add(mentions.Initialize()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: 2,
            child: Builder(
              builder: (context) {
                final blocContext = context;

                void toggleRead() {
                  context
                      .read<mentions.MentionsBloc>()
                      .add(mentions.ShowAllToggled());
                  context
                      .read<replies.RepliesBloc>()
                      .add(replies.ShowAllToggled());
                }

                return SetPageInfo(
                  indexOfRelevantItem: 1,
                  actions: [
                    BlocProvider.value(
                      value:
                          BlocProvider.of<mentions.MentionsBloc>(blocContext),
                      child: BlocBuilder<mentions.MentionsBloc,
                          mentions.MentionsState>(
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
          );
        },
      ),
    );
  }
}
