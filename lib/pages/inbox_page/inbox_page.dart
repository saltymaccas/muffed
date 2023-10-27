import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        child: DefaultTabController(
          length: 2,
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
                ))
              ];
            },
            body: TabBarView(children: [RepliesScreen(), MentionsScreen()]),
          ),
        ));
  }
}
