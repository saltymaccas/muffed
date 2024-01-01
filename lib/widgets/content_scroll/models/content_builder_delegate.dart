import 'package:flutter/material.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/user/user.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/comment/comment.dart';
import 'package:muffed/widgets/post/post.dart';

class ContentBuilderDelegate<Data> {
  const ContentBuilderDelegate();

  /// Builds an individual item
  Widget itemBuilder(BuildContext context, int index, List<Data> content) {
    return Text('Item $index ${content[index]}');
  }

  /// Builds a whole sliver list
  Widget buildSliverList(BuildContext context, List<Data> content, {Key? key}) {
    return SliverList.builder(
      key: key,
      itemCount: content.length,
      itemBuilder: (context, index) => itemBuilder(context, index, content),
    );
  }
}

class LemmyPostContentBuilderDelegate
    extends ContentBuilderDelegate<LemmyPost> {
  @override
  Widget itemBuilder(BuildContext context, int index, List<LemmyPost> content) {
    return PostWidget(
      key: ValueKey(content[index].id),
      post: content[index],
      form: PostViewForm.card,
      displayType: PostDisplayType.list,
    );
  }
}

class LemmyCommentTreeContentBuilderDelegate
    extends ContentBuilderDelegate<LemmyComment> {
  LemmyCommentTreeContentBuilderDelegate(this.sortType);

  final LemmyCommentSortType sortType;

  @override
  Widget buildSliverList(
    BuildContext context,
    List<LemmyComment> content, {
    Key? key,
  }) {
    final organisedComments = organiseCommentsWithChildren(0, content);

    return SliverList.builder(
      key: key,
      itemCount: organisedComments.length,
      itemBuilder: (context, index) {
        return CommentTreeItemWidget(
          key: ValueKey(organisedComments[index].comment.id),
          comment: organisedComments[index].comment,
          children: organisedComments[index].children,
          sortType: sortType,
        );
      },
    );
  }
}

class ContentBuilderDelegateLemmyCommentCard
    extends ContentBuilderDelegate<LemmyComment> {
  @override
  Widget itemBuilder(
    BuildContext context,
    int index,
    List<LemmyComment> content,
  ) {
    return CommentCardWidget(
      comment: content[index],
    );
  }
}

class ContentBuilderDelegateLemmyCommunity
    extends ContentBuilderDelegate<LemmyCommunity> {
  @override
  Widget itemBuilder(
    BuildContext context,
    int index,
    List<LemmyCommunity> content,
  ) {
    return CommunityListTile(content[index]);
  }
}

class ContentBuilderDelegateLemmyUser
    extends ContentBuilderDelegate<LemmyUser> {
  @override
  Widget itemBuilder(BuildContext context, int index, List<LemmyUser> content) {
    return UserListTile(person: content[index]);
  }
}
