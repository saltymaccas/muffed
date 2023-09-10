import 'package:muffed/repo/lemmy/models.dart';

List<LemmyComment> organiseComments(List<LemmyComment> inputComments) {
  List<LemmyComment> comments = inputComments.toSet().toList();

  List<LemmyComment> toBeRemoved = [];

  for (final comment in comments) {
    for (final comment2 in comments) {
      if (comment != comment2 &&
          !toBeRemoved.contains(comment) &&
          !toBeRemoved.contains(comment2)) {
        final bool success = comment.addCommentToTree(comment2);
        if (success) {
          toBeRemoved.add(comment2);
        }
      }
    }
  }

  for (final comment in toBeRemoved) {
    comments.remove(comment);
  }

  return comments;
}
