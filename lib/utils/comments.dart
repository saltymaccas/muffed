// import 'package:muffed/repo/lemmy/models.dart';
//
// List<LemmyComment> organiseComments(List<LemmyComment> inputComments) {
//   List<LemmyComment> comments = inputComments.toSet().toList();
//
//   List<LemmyComment> toBeRemoved = [];
//
//   for (final comment in comments) {
//     for (final comment2 in comments) {
//       if (comment != comment2 &&
//           !toBeRemoved.contains(comment) &&
//           !toBeRemoved.contains(comment2)) {
//         final bool success = comment.addCommentToTree(comment2);
//         if (success) {
//           toBeRemoved.add(comment2);
//         }
//       }
//     }
//   }
//
//   for (final comment in toBeRemoved) {
//     comments.remove(comment);
//   }
//
//   return comments;
// }

import 'package:muffed/repo/lemmy/models.dart';

/// Organises comments, [level] is the level to organise the comments on
/// returns a map the key being the parent on the right level and the value
/// being the children and grandchildren of the parent
Map<LemmyComment, List<LemmyComment>> organiseCommentsWithChildren(
  int level,
  List<LemmyComment> comments,
) {
  final Map<LemmyComment, List<LemmyComment>> organisedComments = {};

  for (int i = 0; i < comments.length; i++) {
    final baseComment = comments[i];
    // if the comment is on the right level
    if (baseComment.getLevel() == level) {
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
