part of 'bloc.dart';

enum ContentScrollStatus { initial, loading, success, failure }

final class ContentScrollState extends Equatable {
  const ContentScrollState({
    required this.status,
    required this.retrieveContent,
    this.content,
    this.isRefreshing = false,
    this.pagesLoaded = 0,
    this.isLoadingMore = false,
    this.exception,
    this.reachedEnd = false,
    this.isLoading = false,
    ContentRetriever? loadedRetrieveContent,
  }) : loadedRetrieveContent = loadedRetrieveContent ?? retrieveContent;

  final ContentScrollStatus status;
  final List<Object>? content;
  final bool isRefreshing;
  final int pagesLoaded;
  final bool isLoadingMore;

  /// If status set to failure error message should display instead of posts.
  /// If status is success the error message should appear as a snack bar so
  /// the posts are still visible.
  final MException? exception;

  final bool reachedEnd;

  /// The method that should be used to retrieve content
  final ContentRetriever retrieveContent;

  /// The content retriever that was used to load the currently displayed
  /// content
  final ContentRetriever loadedRetrieveContent;

  final bool isLoading;

  @override
  List<Object?> get props => [
        content,
        status,
        isRefreshing,
        pagesLoaded,
        isLoadingMore,
        exception,
        reachedEnd,
        retrieveContent,
        isLoading,
        loadedRetrieveContent,
      ];

  ContentScrollState copyWith({
    MException? exception,
    ContentScrollStatus? status,
    List<Object>? content,
    bool? isRefreshing,
    int? pagesLoaded,
    bool? reachedEnd,
    ContentRetriever? retrieveContent,
    ContentRetriever? loadedRetrieveContent,
    bool? isLoading,
    bool? isLoadingMore,
  }) {
    return ContentScrollState(
      exception: exception,
      status: status ?? this.status,
      content: content ?? this.content,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      retrieveContent: retrieveContent ?? this.retrieveContent,
      loadedRetrieveContent:
          loadedRetrieveContent ?? this.loadedRetrieveContent,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
