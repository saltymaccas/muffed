import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/pages/inbox_page/replies_screen/replies_screen.dart';
import 'package:muffed/repo/server_repo.dart';

import 'mentions_screen/bloc/bloc.dart' as mentions;
import 'mentions_screen/mentions_screen.dart';
import 'replies_screen/bloc/bloc.dart' as replies;

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabController = TabController(length: 2, vsync: this);

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
          final blocContext = context;

          tabController.addListener(() {
            if (tabController.previousIndex != tabController.index) {
              if (tabController.index == 0) {
                context.read<DynamicNavigationBarBloc>().add(EditPageActions(
                    context: context,
                    itemIndex: 1,
                    actions: [Icon(Icons.ac_unit)]));
              } else {
                context.read<DynamicNavigationBarBloc>().add(
                      EditPageActions(
                        context: context,
                        itemIndex: 1,
                        actions: [
                          BlocProvider.value(
                            value: BlocProvider.of<mentions.MentionsBloc>(
                              blocContext,
                            ),
                            child: BlocBuilder<mentions.MentionsBloc,
                                mentions.MentionsState>(
                              builder: (context, state) {
                                return IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    context
                                        .read<mentions.MentionsBloc>()
                                        .add(mentions.ShowAllToggled());
                                  },
                                  icon: Text(
                                    'Show all',
                                    style: (state.showAll)
                                        ? Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )
                                        : Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
              }
            }
          });
          return NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverToBoxAdapter(
                  child: SafeArea(
                    child: TabBar(
                      controller: tabController,
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
              controller: tabController,
              children: [RepliesScreen(), MentionsScreen()],
            ),
          );
        },
      ),
    );
  }
}
