import 'package:lemmy_api_client/v3.dart';

class CommentTree {
  CommentTree({
    required this.comment,
    required this.level,
    required this.children,
  });
  CommentView comment;
  List<CommentTree> children;
  int level;

  static List<CommentTree> assembleCommentTree(List<CommentView> comments) {
    final commentMap = <String, CommentTree>{};

    // Create a map of CommentView objects using the comment path as the key
    for (final comment in comments) {
      commentMap[comment.comment.path] = CommentTree(
        comment: comment,
        children: [],
        level: comment.comment.path.split('.').length - 2,
      );
    }

    // Build the tree structure by assigning children to their parent comments
    for (final comment in commentMap.values) {
      final pathIds = comment.comment.comment.path.split('.');
      final parentPath = pathIds.getRange(0, pathIds.length - 1).join('.');

      final parentCommentView = commentMap[parentPath];

      if (parentCommentView != null) {
        parentCommentView.children.add(comment);
      }
    }

    // Return the root comments (those with an empty or "0" path)
    return commentMap.values
        .where(
          (commentView) =>
              commentView.comment.comment.path.isEmpty ||
              commentView.comment.comment.path ==
                  '0.${commentView.comment.comment.id}',
        )
        .toList();
  }
}
