import 'package:muffed/components/lemmy_comment/comment.dart';

/// Organizes the comment into tree structure.
///
/// gets every comment on the same level as [level] and places them into the key
/// and puts all of its descendants into the value
Map<LemmyComment, List<LemmyComment>> organiseCommentsWithChildren(
  int level,
  List<LemmyComment> comments,
) {
  final Map<LemmyComment, List<LemmyComment>> organisedComments = {};

  for (int i = 0; i < comments.length; i++) {
    final baseComment = comments[i];
    // if the comment is on the right level
    if (baseComment.level == level) {
      organisedComments[baseComment] = [];
      for (int i2 = 0; i2 < comments.length; i2++) {
        final childComment = comments[i2];
        if (childComment.path.contains(baseComment.id)) {
          organisedComments[baseComment]!.add(childComment);
        }
      }
    }
  }

  return organisedComments;
}
