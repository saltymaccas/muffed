part of 'bloc.dart';

@freezed
class CommentScrollState with _$CommentScrollState {
  const factory CommentScrollState({
    required PagedScrollViewStatus status,
    required int pagesLoaded,
    required bool allPagesLoaded,
    required CommentSortType sort,
    List<CommentTree>? comments,
    String? errorMessage,
  }) = _CommentScrollState;
}
