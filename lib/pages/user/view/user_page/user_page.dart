import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/user/user.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/router.dart';
import 'package:muffed/theme/theme.dart';
import 'package:muffed/widgets/comment/comment.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';
import 'package:muffed/widgets/image.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/muffed_avatar.dart';
import 'package:muffed/widgets/post/post.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'header.dart';
part 'user_info_tab_view.dart';

const _headerMaxHeight = 300.0;
const _headerMinHeight = 130.0;
const _bannerEndFraction = 0.6;

class UserPage extends MPage<void> {
  const UserPage({this.userId, this.username})
      : assert(
          userId != null || username != null,
          'Both userId and username equals null',
        );

  final int? userId;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentScrollBloc(
        contentRetriever: UserContentRetriever(
          repo: context.read<ServerRepo>(),
          userId: userId,
          username: username,
        ),
      )..add(LoadInitialItems()),
      child: const UserView(),
    );
  }
}

/// Displays a users profile
class UserView extends StatelessWidget {
  /// Shows a users profile, either the id or name needs to be defined
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentScrollBloc<LemmyGetPersonDetailsResponse>,
        ContentScrollState<LemmyGetPersonDetailsResponse>>(
      builder: (context, state) {
        final user = state.content.elementAtOrNull(0)?.person;

        return DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                const _UserPostsTabView(key: PageStorageKey('user-comments')),
                const _UserCommentsTabView(
                  key: PageStorageKey('user-posts'),
                ),
              ],
            ),
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
      builderDelegate: PostBuilderDelegate(),
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
      builderDelegate: ContentBuilderDelegateUserComments(),
    );
  }
}

class PostBuilderDelegate
    extends ContentBuilderDelegate<LemmyGetPersonDetailsResponse> {
  @override
  Widget buildSliverList(
    BuildContext context,
    List<LemmyGetPersonDetailsResponse> content, {
    Key? key,
  }) {
    final items = content.expand((element) => element.posts).toList();

    return SliverList.list(
      key: key,
      children: List.generate(
        items.length,
        (index) => PostWidget(
          post: items[index],
          form: PostViewForm.card,
          displayType: PostDisplayType.list,
        ),
      ),
    );
  }
}

class ContentBuilderDelegateUserComments
    extends ContentBuilderDelegate<LemmyGetPersonDetailsResponse> {
  @override
  Widget buildSliverList(
    BuildContext context,
    List<LemmyGetPersonDetailsResponse> content, {
    Key? key,
  }) {
    final items = content.expand((element) => element.comments).toList();

    return SliverList.list(
      key: key,
      children: List.generate(
        items.length,
        (index) => CommentWidget.card(
          comment: items[index],
          sortType: LemmyCommentSortType.hot,
        ),
      ),
    );
  }
}
