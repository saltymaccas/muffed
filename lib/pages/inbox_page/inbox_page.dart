import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/dynamic_navigation_bar/bloc/bloc.dart';
import 'package:muffed/pages/inbox_page/replies_screen/replies_screen.dart';
import 'package:muffed/repo/server_repo.dart';

import '../../components/popup_menu/popup_menu.dart';
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
          context.read<DynamicNavigationBarBloc>().add(
                EditPageActions(
                  context: context,
                  itemIndex: 1,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              );

          return DefaultTabController(
            animationDuration: Duration(milliseconds: 200),
            length: 2,
            child: Builder(
              builder: (context) {
                final blocContext = context;

                final tabController = DefaultTabController.of(context);

                tabController.animation!.addListener(() {
                  context.read<DynamicNavigationBarBloc>().add(
                        EditPageActions(
                          context: context,
                          itemIndex: 1,
                          actions: [],
                        ),
                      );
                });

                tabController.addListener(() {
                  if (tabController.index == 0) {
                    context.read<DynamicNavigationBarBloc>().add(
                          EditPageActions(
                            context: context,
                            itemIndex: 1,
                            actions: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_vert),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        );
                  } else if (tabController.index == 1) {
                    context.read<DynamicNavigationBarBloc>().add(
                          EditPageActions(
                            context: context,
                            itemIndex: 1,
                            actions: [
                              MuffedPopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                visualDensity: VisualDensity.compact,
                                items: [
                                  BlocProvider.value(
                                    value:
                                        BlocProvider.of<mentions.MentionsBloc>(
                                      blocContext,
                                    ),
                                    child: BlocBuilder<mentions.MentionsBloc,
                                        mentions.MentionsState>(
                                      builder: (context, state) {
                                        return MuffedPopupMenuItem(
                                          title: (state.showAll)
                                              ? 'Hide read'
                                              : 'Show read',
                                          onTap: () {
                                            context
                                                .read<mentions.MentionsBloc>()
                                                .add(
                                                  mentions.ShowAllToggled(),
                                                );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                  }
                });

                return NestedScrollView(
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
