part of 'bloc.dart';

class CommentItemState extends Equatable {
  CommentItemState({
    required this.comment,
    this.error,
  });

  final LemmyComment comment;
  final Object? error;

  @override
  List<Object?> get props => [
        comment,
        error,
      ];
}
