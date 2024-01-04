import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/db/local_store.dart';
import 'package:muffed/pages/community/view/community_page.dart';
import 'package:muffed/pages/profile/profile.dart';
import 'package:muffed/pages/user/models/content_retriever.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/content_scroll/bloc/bloc.dart';
import 'package:muffed/widgets/content_scroll/models/content_builder_delegate.dart';
import 'package:muffed/widgets/content_scroll/models/content_retriever_delegate.dart';
import 'package:muffed/widgets/content_scroll/widgets/content_scroll_view.dart';
import 'package:muffed/widgets/image.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'user_info_tab_view.dart';
part 'header.dart';

const _headerMaxHeight = 300.0;
const _headerMinHeight = 130.0;
const _bannerEndFraction = 0.6;

class ProfilePage extends MPage<void> {
  ProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DB, DBModel>(
      builder: (context, state) {
        if (state.isLoggedIn) {
          return const _LoggedInProfileView();
        } else {
          return const _NotLoggedInProfileView();
        }
      },
    );
  }
}

class _NotLoggedInProfileView extends StatelessWidget {
  const _NotLoggedInProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'Anonymous',
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                showAccountSwitcher(context);
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedInProfileView extends StatelessWidget {
  const _LoggedInProfileView();

  @override
  Widget build(BuildContext context) {
    final globalBloc = context.read<DB>();

    return BlocBuilder<DB, DBModel>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ContentScrollBloc(
            contentRetriever: UserContentRetriever(
              repo: context.read<ServerRepo>(),
              userId: state.selectedLemmyAccount!.id,
              username: state.selectedLemmyAccount!.name,
            ),
          )..add(LoadInitialItems()),
          child: BlocBuilder<ContentScrollBloc<LemmyGetPersonDetailsResponse>,
              ContentScrollState<LemmyGetPersonDetailsResponse>>(
            builder: (context, state) {
              final user = state.content.elementAtOrNull(0)?.person;

              return Scaffold(
                body: DefaultTabController(
                  length: 3,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      // These are the slivers that show up in the "outer" scroll view.
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                          sliver: SliverPersistentHeader(
                            delegate: _HeaderDelegate(user: user),
                            pinned: true,
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        _UserInfoTabView(user: user),
                        const _UserPostsTabView(
                          key: PageStorageKey('user-comments'),
                        ),
                        const _UserCommentsTabView(
                          key: PageStorageKey('user-posts'),
                        ),
                      ],
                    ),
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

class _UserPostsTabView extends StatelessWidget {
  const _UserPostsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentScrollView<LemmyGetPersonDetailsResponse>(
      headerSlivers: const [
        SliverToBoxAdapter(
          child: SizedBox(
            height: _headerMinHeight,
          ),
        ),
      ],
      builderDelegate: UserPostBuilderDelegate(),
    );
  }
}

class _UserCommentsTabView extends StatelessWidget {
  const _UserCommentsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentScrollView<LemmyGetPersonDetailsResponse>(
      headerSlivers: const [
        SliverToBoxAdapter(
          child: SizedBox(
            height: _headerMinHeight,
          ),
        ),
      ],
      builderDelegate: UserCommentsBuilderDelegate(),
    );
  }
}
