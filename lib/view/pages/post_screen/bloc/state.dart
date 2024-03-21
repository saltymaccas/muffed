part of 'bloc.dart';

@freezed
class CommentScrollState with _$CommentScrollState {
  const factory CommentScrollState({
    required PagedScrollViewStatus status,
    required int pagesLoaded,
    required bool allPagedLoaded,
    required CommentSortType sort,
    List<CommentTree>? comments,
  }) = _CommentScrollState;
}
