import 'package:equatable/equatable.dart';


class LemmyCommentTree extends Equatable {
  LemmyComment(this.comment, this.children);


  final LemmyComment comment;
  final List<LemmyComment> children;

  @override
  // TODO: implement props
  List<Object?> get props => [comment, children];
}
