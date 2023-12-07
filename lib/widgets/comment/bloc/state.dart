part of 'bloc.dart';

class CommentItemState extends Equatable {
  const CommentItemState({
    required this.comment,
    required this.children,
    required this.sortType,
    this.error,
    this.loadingChildren = false,
    this.minimised = false,
  });

  final List<LemmyComment> children;
  final LemmyComment comment;
  final MException? error;
  final bool loadingChildren;
  final bool minimised;
  final LemmyCommentSortType sortType;

  @override
  List<Object?> get props => [
        sortType,
        comment,
        children,
        error,
        loadingChildren,
        minimised,
      ];

  CommentItemState copyWith({
    LemmyCommentSortType? sortType,
    List<LemmyComment>? children,
    LemmyComment? comment,
    MException? error,
    bool? loadingChildren,
    bool? minimised,
  }) {
    return CommentItemState(
      sortType: sortType ?? this.sortType,
      children: children ?? this.children,
      comment: comment ?? this.comment,
      error: error,
      loadingChildren: loadingChildren ?? this.loadingChildren,
      minimised: minimised ?? this.minimised,
    );
  }
}
