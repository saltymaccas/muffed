part of 'bloc.dart';

class CommentState extends Equatable {
  const CommentState({
    required this.comment,
    required this.children,
    required this.sortType,
    this.error,
    this.loadingChildren = false,
  });

  final List<LemmyComment> children;
  final LemmyComment comment;
  final MException? error;
  final bool loadingChildren;
  final LemmyCommentSortType sortType;

  @override
  List<Object?> get props => [
        sortType,
        comment,
        children,
        error,
        loadingChildren,
      ];

  CommentState copyWith({
    LemmyCommentSortType? sortType,
    List<LemmyComment>? children,
    LemmyComment? comment,
    MException? error,
    bool? loadingChildren,
  }) {
    return CommentState(
      sortType: sortType ?? this.sortType,
      children: children ?? this.children,
      comment: comment ?? this.comment,
      error: error,
      loadingChildren: loadingChildren ?? this.loadingChildren,
    );
  }
}
