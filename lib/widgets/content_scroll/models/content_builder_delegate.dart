import 'package:flutter/cupertino.dart';
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
  Widget buildSliverList(BuildContext context, List<Data> content) {
    return SliverList.builder(
      itemCount: content.length,
      itemBuilder: (context, index) => itemBuilder(context, index, content),
    );
  }

  List<Widget> buildCustomScrollViewElements(
    BuildContext context,
    List<Data> content,
  ) {
    return [
      buildSliverList(context, content),
    ];
  }
}

class LemmyPostContentBuilderDelegate
    extends ContentBuilderDelegate<LemmyPost> {
  @override
  Widget itemBuilder(BuildContext context, int index, List<LemmyPost> content) {
    return PostWidget(
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
  Widget buildSliverList(BuildContext context, List<LemmyComment> content) {
    final organisedComments = organiseCommentsWithChildren(0, content);

    return SliverList.builder(
      itemCount: organisedComments.length,
      itemBuilder: (context, index) {
        return CommentWidget.tree(
          comment: organisedComments[index].comment,
          children: organisedComments[index].children,
          sortType: sortType,
        );
      },
    );
  }
}
