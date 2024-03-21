import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';

part 'models.freezed.dart';

@freezed
class CommentTree with _$CommentTree {
  const factory CommentTree({
    required CommentView comment,
    required List<CommentTree> children,
  }) = _CommentTree;

  static List<CommentTree> assembleCommentTree(List<CommentView> comments) {
    final commentTree = <CommentTree>[];

    for (final c in comments) {
      commentTree.add(CommentTree(comment: c, children: []));
    }

    return commentTree;
  }
}
