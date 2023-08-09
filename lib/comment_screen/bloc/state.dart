part of 'bloc.dart';

enum CommentScreenStatus { initial, loading, success, failure }

class CommentScreenState extends Equatable {

  ///
  const CommentScreenState({
    required this.status,
    this.comments,
    this.pagesLoaded = 0,
    this.isLoading = false,
    this.reachedEnd = false,
    this.errorMessage,
    this.isRefreshing = false,
    this.sortType = LemmyCommentSortType.hot,
  });

  final CommentScreenStatus status;

  final List<LemmyComment>? comments;

  final int pagesLoaded;
  final bool isLoading;
  final LemmyCommentSortType sortType;

  /// whether all the comment pages have been loaded, so there are no more
  /// comment to be loaded
  final bool reachedEnd;

  /// The error message that appears instead of the comments if the comment
  /// screen state is failure. If the comment screen state is loaded it will
  /// appear as a snack bar.
  final String? errorMessage;

  final bool isRefreshing;

  @override
  List<Object?> get props =>
      [
        status,
        comments,
        pagesLoaded,
        isLoading,
        reachedEnd,
        errorMessage,
        isRefreshing,
        sortType,
      ];

  CommentScreenState copyWith({
    bool? isRefreshing,
    String? errorMessage,
    bool? reachedEnd,
    bool? isLoading,
    CommentScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
    LemmyCommentSortType? sortType
  }) {
    return CommentScreenState(
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      sortType: sortType ?? this.sortType,
    );
  }
}
