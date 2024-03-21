part of 'bloc.dart';

@freezed
class CommentState with _$CommentState {
  const factory CommentState({
    required CommentView comment,
    required List<CommentTree> children,
    required int level,
  }) = _CommentState;
}
