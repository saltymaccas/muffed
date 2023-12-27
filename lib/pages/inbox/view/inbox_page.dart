import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/pages/inbox/inbox.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

class InboxPage extends MPage<void> {
  InboxPage() : super(pageActions: PageActions(const []));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        if (!state.isLoggedIn) {
          return const Center(
            child: Text('You must be logged in to view your inbox'),
          );
        }

        return BlocProvider(
          create: (context) => InboxBloc(),
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final inboxBloc = context.read<InboxBloc>();
                super.pageActions!.setActions([
                  BlocBuilder<InboxBloc, InboxState>(
                    bloc: inboxBloc,
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          inboxBloc.add(ShowUnreadToggled());
                        },
                        icon: state.showUnreadOnly
                            ? const Icon(
                                Icons.remove_red_eye_outlined,
                              )
                            : Icon(
                                Icons.remove_red_eye,
                                color: context.colorScheme.primary,
                              ),
                        visualDensity: VisualDensity.compact,
                      );
                    },
                  ),
                ]);
              });
              return const InboxView();
            },
          ),
        );
      },
    );
  }
}

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            appBar: TabBar(tabs: [
              Tab(
                child: Text('Replies'),
              ),
              Tab(
                child: Text('Mentions'),
              ),
            ],),
            body: TabBarView(
              children: [
                _RepliesScrollView(),
                _MentionsScrollView(),
              ],
            ),
          ),
        ),);
  }
}

class _RepliesScrollView extends StatefulWidget {
  const _RepliesScrollView();

  @override
  State<_RepliesScrollView> createState() => _RepliesScrollViewState();
}

class _RepliesScrollViewState extends State<_RepliesScrollView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => ContentScrollBloc(
        contentRetriever: InboxRepliesRetrieverDelegate(
          repo: context.read<ServerRepo>(),
          unreadOnly: context.read<InboxBloc>().state.showUnreadOnly,
        ),
      )..add(LoadInitialItems()),
      child: Builder(
        builder: (context) {
          return BlocListener<InboxBloc, InboxState>(
            listener: (context, state) {
              final scrollBloc =
                  context.read<ContentScrollBloc<LemmyInboxReply>>();

              scrollBloc.add(
                RetrieveContentDelegateChanged(
                  (scrollBloc.state.contentDelegate
                          as InboxRepliesRetrieverDelegate)
                      .copyWith(unreadOnly: state.showUnreadOnly),
                ),
              );
            },
            child: const ContentScrollView(
              builderDelegate: _RepliesBuilderDelegate(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _RepliesBuilderDelegate extends ContentBuilderDelegate<LemmyInboxReply> {
  const _RepliesBuilderDelegate();

  @override
  Widget itemBuilder(
      BuildContext context, int index, List<LemmyInboxReply> items,) {
    return InboxReplyItem(
      item: items[index],
      sortType: LemmyCommentSortType.hot,
    );
  }
}

class _MentionsScrollView extends StatefulWidget {
  const _MentionsScrollView();

  @override
  State<_MentionsScrollView> createState() => _MentionsScrollViewState();
}

class _MentionsScrollViewState extends State<_MentionsScrollView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => ContentScrollBloc(
        contentRetriever: InboxMentionsRetrieverDelegate(
          repo: context.read<ServerRepo>(),
          unreadOnly: context.read<InboxBloc>().state.showUnreadOnly,
        ),
      )..add(LoadInitialItems()),
      child: Builder(
        builder: (context) {
          return BlocListener<InboxBloc, InboxState>(
            listener: (context, state) {
              final scrollBloc =
                  context.read<ContentScrollBloc<LemmyInboxMention>>();

              scrollBloc.add(
                RetrieveContentDelegateChanged(
                  (scrollBloc.state.contentDelegate
                          as InboxMentionsRetrieverDelegate)
                      .copyWith(unreadOnly: state.showUnreadOnly),
                ),
              );
            },
            child: const ContentScrollView(
              builderDelegate: _MentionsBuilderDelegate(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MentionsBuilderDelegate
    extends ContentBuilderDelegate<LemmyInboxMention> {
  const _MentionsBuilderDelegate();

  @override
  Widget itemBuilder(
    BuildContext context,
    int index,
    List<LemmyInboxMention> items,
  ) {
    return InboxMentionItem(
      item: items[index],
      sortType: LemmyCommentSortType.hot,
    );
  }
}
