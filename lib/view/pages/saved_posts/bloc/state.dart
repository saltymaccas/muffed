part of 'bloc.dart';

enum SavedPostsStatus { initial, loading, success, failure }

class SavedPostsState extends Equatable {
  const SavedPostsState({
    this.posts = const [],
    this.status = SavedPostsStatus.initial,
    this.sortType = LemmySortType.latest,
    this.error,
    this.pagesLoaded = 0,
    this.isLoading = false,
    this.reachedEnd = false,
  });

  final SavedPostsStatus status;
  final List<LemmyPost> posts;
  final Object? error;
  final LemmySortType sortType;
  final int pagesLoaded;
  final bool isLoading;
  final bool reachedEnd;

  @override
  List<Object?> get props => [
        posts,
        status,
        error,
        sortType,
        pagesLoaded,
        isLoading,
        reachedEnd,
      ];

  SavedPostsState copyWith({
    SavedPostsStatus? status,
    List<LemmyPost>? posts,
    Object? error,
    LemmySortType? sortType,
    int? pagesLoaded,
    bool? isLoading,
    bool? reachedEnd,
  }) {
    return SavedPostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      error: error,
      sortType: sortType ?? this.sortType,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      isLoading: isLoading ?? this.isLoading,
      reachedEnd: reachedEnd ?? this.reachedEnd,
    );
  }
}
