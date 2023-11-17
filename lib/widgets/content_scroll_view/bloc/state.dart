part of 'bloc.dart';

enum ContentScrollStatus { initial, loading, success, failure }

final class ContentScrollState extends Equatable {
  ///
  const ContentScrollState({
    required this.status,
    this.content,
    this.isRefreshing = false,
    this.pagesLoaded = 0,
    this.isLoadingMore = false,
    this.error,
    this.reachedEnd = false,
  });

  /// Status should only be changed after posts have been loaded
  final ContentScrollStatus status;
  final List<Object>? content;
  final bool isRefreshing;
  final int pagesLoaded;
  final bool isLoadingMore;

  /// If status set to failure error message should display instead of posts.
  /// If status is success the error message should appear as a snack bar so
  /// the posts are still visible.
  final Object? error;

  final bool reachedEnd;

  @override
  List<Object?> get props => [
        content,
        status,
        isRefreshing,
        pagesLoaded,
        isLoadingMore,
        error,
        reachedEnd,
      ];

  ContentScrollState copyWith({
    Object? errorMessage,
    ContentScrollStatus? status,
    List<Object>? content,
    bool? isRefreshing,
    int? pagesLoaded,
    bool? isLoading,
    LemmyListingType? listingType,
    bool? reachedEnd,
  }) {
    return ContentScrollState(
      error: errorMessage,
      status: status ?? this.status,
      content: content ?? this.content,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      isLoadingMore: isLoading ?? this.isLoadingMore,
      reachedEnd: reachedEnd ?? this.reachedEnd,
    );
  }
}
