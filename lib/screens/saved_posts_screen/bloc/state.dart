part of 'bloc.dart';

enum SavedPostsStatus { initial, loading, success, failure }

class SavedPostsState extends Equatable {
  SavedPostsState({
    this.posts = const [],
    this.status = SavedPostsStatus.initial,
    this.sortType = LemmySortType.latest,
    this.error,
    this.pagesLoaded = 0,
  });

  final SavedPostsStatus status;
  final List<LemmyPost> posts;
  final Object? error;
  final LemmySortType sortType;
  final int pagesLoaded;

  @override
  List<Object?> get props => [
        posts,
        status,
        error,
        sortType,
      ];

  SavedPostsState copyWith({
    SavedPostsStatus? status,
    List<LemmyPost>? posts,
    Object? error,
    LemmySortType? sortType,
    int? pagesLoaded,
  }) {
    return SavedPostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      error: error,
      sortType: sortType ?? this.sortType,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
    );
  }
}
