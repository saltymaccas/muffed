part of 'bloc.dart';

class CommentItemState extends Equatable {
  CommentItemState({
    required this.comment,
    required this.children,
    this.error,
    this.loadingChildren = false,
    this.minimised = false,
  });

  final List<LemmyComment> children;
  final LemmyComment comment;
  final Object? error;
  final bool loadingChildren;
  final bool minimised;

  @override
  List<Object?> get props => [
        comment,
        children,
        error,
        loadingChildren,
        minimised,
      ];

  CommentItemState copyWith({
    List<LemmyComment>? children,
    LemmyComment? comment,
    Object? error,
    bool? loadingChildren,
    bool? minimised,
  }) {
    return CommentItemState(
      children: children ?? this.children,
      comment: comment ?? this.comment,
      error: error,
      loadingChildren: loadingChildren ?? this.loadingChildren,
      minimised: minimised ?? this.minimised,
    );
  }
}
