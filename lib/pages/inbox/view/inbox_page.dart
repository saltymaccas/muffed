import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/inbox/inbox.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/models.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

class InboxPage extends MPage<void> {
  InboxPage() : super(pageActions: PageActions(const []));

  @override
  Widget build(BuildContext context) {
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
                        ? const Icon(Icons.remove_red_eye)
                        : Icon(
                            Icons.remove_red_eye_outlined,
                            color: context.colorScheme.primary,
                          ),
                    visualDensity: VisualDensity.compact,
                  );
                },
              )
            ]);
          });
          return const InboxView();
        },
      ),
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
              )
            ]),
            body: TabBarView(
              children: [
                _RepliesScrollView(),
                _MentionsScrollView(),
              ],
            ),
          ),
        ));
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
        contentRetriever: InboxRepliesRetriever(
          repo: context.read<ServerRepo>(),
          unreadOnly: context.read<InboxBloc>().state.showUnreadOnly,
        ),
      )..add(Initialise()),
      child: Builder(
        builder: (context) {
          return BlocListener<InboxBloc, InboxState>(
            listener: (context, state) {
              final scrollBloc = context.read<ContentScrollBloc>();

              scrollBloc.add(
                RetrieveContentMethodChanged(
                  (scrollBloc.state.retrieveContent as InboxRepliesRetriever)
                      .copyWith(unreadOnly: state.showUnreadOnly),
                ),
              );
            },
            child: ContentScrollView(
              itemBuilder: (context, index, item) =>
                  InboxReplyItem(item: item as LemmyInboxReply),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MentionsScrollView extends StatefulWidget {
  const _MentionsScrollView({super.key});

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
        contentRetriever: InboxMentionsRetriever(
          repo: context.read<ServerRepo>(),
          unreadOnly: context.read<InboxBloc>().state.showUnreadOnly,
        ),
      )..add(Initialise()),
      child: Builder(
        builder: (context) {
          return BlocListener<InboxBloc, InboxState>(
            listener: (context, state) {
              final scrollBloc = context.read<ContentScrollBloc>();

              scrollBloc.add(
                RetrieveContentMethodChanged(
                  (scrollBloc.state.retrieveContent as InboxMentionsRetriever)
                      .copyWith(unreadOnly: state.showUnreadOnly),
                ),
              );
            },
            child: ContentScrollView(
              itemBuilder: (context, index, item) =>
                  InboxMentionItem(item: item as LemmyInboxMention),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}