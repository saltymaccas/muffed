part of 'bloc.dart';

// make inbox status enum
enum RepliesStatus {
  initial,
  loading,
  success,
  failure,
}

class RepliesState extends Equatable {
  const RepliesState({
    this.isLoading = false,
    this.replies = const [],
    this.error,
    this.replyItemsStatus = RepliesStatus.initial,
    this.sortType = LemmyCommentSortType.hot,
    this.showAll = false,
    this.pagesLoaded = 1,
    this.isRefreshing = false,
    this.reachedEnd = false,
  });

  final RepliesStatus replyItemsStatus;
  final bool isLoading;
  final Object? error;
  final List<LemmyInboxReply> replies;
  final LemmyCommentSortType sortType;
  final bool showAll;
  final int pagesLoaded;
  final bool isRefreshing;
  final bool reachedEnd;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        replies,
        replyItemsStatus,
        sortType,
        showAll,
        pagesLoaded,
        isRefreshing,
        reachedEnd,
      ];

  RepliesState copyWith({
    bool? isLoading,
    Object? error,
    List<LemmyInboxReply>? replies,
    RepliesStatus? inboxStatus,
    LemmyCommentSortType? sortType,
    bool? showAll,
    int? pagesLoaded,
    bool? isRefreshing,
    bool? reachedEnd,
  }) {
    return RepliesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      replies: replies ?? this.replies,
      replyItemsStatus: inboxStatus ?? this.replyItemsStatus,
      sortType: sortType ?? this.sortType,
      showAll: showAll ?? this.showAll,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      reachedEnd: reachedEnd ?? this.reachedEnd,
    );
  }
}
