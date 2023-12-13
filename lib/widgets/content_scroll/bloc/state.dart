part of 'bloc.dart';

enum ContentScrollStatus {
  empty,
  loading,
  success,
  failure;

  bool get isEmpty => this == ContentScrollStatus.empty;

  bool get isLoading => this == ContentScrollStatus.loading;

  bool get isSuccess => this == ContentScrollStatus.success;

  bool get isFailure => this == ContentScrollStatus.failure;
}

final class ContentScrollState<Data> extends Equatable {
  const ContentScrollState({
    required this.status,
    required this.contentDelegate,
    this.content = const [],
    this.isReloading = false,
    this.pagesLoaded = 0,
    this.isLoadingMore = false,
    this.exception,
    this.reachedEnd = false,
    this.isLoading = false,
    ContentRetrieverDelegate<Data>? loadedRetrieveContent,
  }) : loadedContentDelegate = loadedRetrieveContent ?? contentDelegate;

  final ContentScrollStatus status;
  final List<Data> content;
  final bool isReloading;
  final int pagesLoaded;
  final bool isLoadingMore;

  /// If status set to failure error message should display instead of posts.
  /// If status is success the error message should appear as a snack bar so
  /// the posts are still visible.
  final MException? exception;

  final bool reachedEnd;

  /// The method that should be used to retrieve content
  final ContentRetrieverDelegate<Data> contentDelegate;

  /// The content retriever that was used to load the currently displayed
  /// content
  final ContentRetrieverDelegate<Data> loadedContentDelegate;

  final bool isLoading;

  @override
  List<Object?> get props => [
        content,
        status,
        isReloading,
        pagesLoaded,
        isLoadingMore,
        exception,
        reachedEnd,
        contentDelegate,
        isLoading,
        loadedContentDelegate,
      ];

  ContentScrollState<Data> copyWith({
    MException? exception,
    ContentScrollStatus? status,
    List<Data>? content,
    bool? isRefreshing,
    int? pagesLoaded,
    bool? reachedEnd,
    ContentRetrieverDelegate<Data>? contentDelegate,
    ContentRetrieverDelegate<Data>? loadedContentDelegate,
    bool? isLoading,
    bool? isLoadingMore,
  }) {
    return ContentScrollState(
      exception: exception,
      status: status ?? this.status,
      content: content ?? this.content,
      isReloading: isRefreshing ?? this.isReloading,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      contentDelegate: contentDelegate ?? this.contentDelegate,
      loadedRetrieveContent:
          loadedContentDelegate ?? this.loadedContentDelegate,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
