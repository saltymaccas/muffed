import 'package:flutter/material.dart';
import 'package:muffed/interfaces/lemmy/lemmy.dart';
import 'package:muffed/pages/.community/community.dart';
import 'package:muffed/pages/.user/user.dart';
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

class LemmyPostContentBuilderDelegate extends ContentBuilderDelegate<PostView> {
  @override
  Widget itemBuilder(BuildContext context, int index, List<PostView> content) {
    return PostWidget(
      post: content[index],
      form: PostViewForm.card,
      displayType: PostDisplayType.list,
    );
  }
}

class LemmyCommentTreeContentBuilderDelegate
    extends ContentBuilderDelegate<CommentView> {
  LemmyCommentTreeContentBuilderDelegate(this.sortType);

  final CommentSortType sortType;

  @override
  Widget buildSliverList(
    BuildContext context,
    List<CommentView> content, {
    Key? key,
  }) {
    // FIXME
    final organisedComments =
        content; //organiseCommentsWithChildren(0, content);

    return SliverList.builder(
      key: key,
      itemCount: organisedComments.length,
      itemBuilder: (context, index) {
        // FIXME
        // return CommentTreeItemWidget(
        //   key: ValueKey(organisedComments[index].comment.id),
        //   comment: organisedComments[index].comment,
        //   children: organisedComments[index].children,
        //   sortType: sortType,
        // );
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

class UserPostBuilderDelegate
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

class UserCommentsBuilderDelegate
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
        (index) => CommentCardWidget(
          comment: items[index],
        ),
      ),
    );
  }
}
