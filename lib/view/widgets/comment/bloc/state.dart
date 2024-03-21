part of 'bloc.dart';

@freezed
class CommentState with _$CommentState {
  const factory CommentState({
    required CommentTree commentTree,
  }) = _CommentState;
}
