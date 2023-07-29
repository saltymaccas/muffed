part of 'bloc.dart';

enum HomePageStatus { initial, loading, success, failure }

final class HomePageState extends Equatable {
  ///
  const HomePageState({
    required this.status,
    this.posts,
    this.isRefreshing = false,
    this.pagesLoaded = 0,
    this.isLoading = false,
    this.errorMessage,
    this.sortType = LemmySortType.hot,
    this.listingType = LemmyListingType.all,
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
  final LemmySortType sortType;
  final LemmyListingType listingType;

  @override
  List<Object?> get props => [
        posts,
        status,
        isRefreshing,
        pagesLoaded,
        isLoading,
        errorMessage,
        listingType,
        sortType,
      ];

  HomePageState copyWith({
    String? errorMessage,
    HomePageStatus? status,
    List<LemmyPost>? posts,
    bool? isRefreshing,
    int? pagesLoaded,
    bool? isLoading,
    LemmyListingType? listingType,
    LemmySortType? sortType,
  }) {
    return HomePageState(
      errorMessage: errorMessage,
      status: status ?? this.status,
      posts: posts ?? this.posts,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      isLoading: isLoading ?? this.isLoading,
      listingType: listingType ?? this.listingType,
      sortType: sortType ?? this.sortType,
    );
  }
}
