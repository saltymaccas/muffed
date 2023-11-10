part of 'bloc.dart';

enum HomePageStatus { initial, loading, success, failure }

final class HomePageViewState extends Equatable {
  ///
  const HomePageViewState({
    required this.status,
    this.posts,
    this.isRefreshing = false,
    this.pagesLoaded = 0,
    this.isLoading = false,
    this.errorMessage,
    this.sortType = LemmySortType.hot,
    this.loadedSortType = LemmySortType.hot,
  });

  /// Status should only be changed after posts have been loaded
  final HomePageStatus status;
  final List<LemmyPost>? posts;
  final bool isRefreshing;
  final int pagesLoaded;
  final bool isLoading;

  /// If status set to failure error message should display instead of posts.
  /// If status is success the error message should appear as a snack bar so
  /// the posts are still visible.
  final String? errorMessage;

  /// The sort type the user selected
  ///
  /// This gets set as soon as the user sets the sort type, It will be changed
  /// back if an error occurs when loading the posts
  final LemmySortType sortType;

  /// The sort type that is currently loaded
  ///
  /// This sort type gets changed when the sort type gets successfully loaded
  final LemmySortType loadedSortType;

  @override
  List<Object?> get props => [
        posts,
        status,
        isRefreshing,
        pagesLoaded,
        isLoading,
        errorMessage,
        sortType,
        loadedSortType,
      ];

  HomePageViewState copyWith({
    String? errorMessage,
    HomePageStatus? status,
    List<LemmyPost>? posts,
    bool? isRefreshing,
    int? pagesLoaded,
    bool? isLoading,
    LemmyListingType? listingType,
    LemmySortType? sortType,
    LemmySortType? loadedSortType,
  }) {
    return HomePageViewState(
      errorMessage: errorMessage,
      status: status ?? this.status,
      posts: posts ?? this.posts,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      isLoading: isLoading ?? this.isLoading,
      sortType: sortType ?? this.sortType,
      loadedSortType: loadedSortType ?? this.loadedSortType,
    );
  }
}
