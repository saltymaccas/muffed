part of 'bloc.dart';

enum PostScreenStatus { initial, loading, success, failure }

class PostScreenState extends Equatable {
  ///
  const PostScreenState({
    required this.status,
    this.comments,
    this.pagesLoaded = 0,
    this.isLoading = false,
    this.reachedEnd = false,
    this.error,
    this.isRefreshing = false,
    this.sortType = LemmyCommentSortType.hot,
  });

  final PostScreenStatus status;

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
  final Object? error;

  final bool isRefreshing;

  @override
  List<Object?> get props => [
        status,
        comments,
        pagesLoaded,
        isLoading,
        reachedEnd,
        error,
        isRefreshing,
        sortType,
      ];

  PostScreenState copyWith({
    bool? isRefreshing,
    Object? error,
    bool? reachedEnd,
    bool? isLoading,
    PostScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
    LemmyCommentSortType? sortType,
  }) {
    return PostScreenState(
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      sortType: sortType ?? this.sortType,
    );
  }
}
