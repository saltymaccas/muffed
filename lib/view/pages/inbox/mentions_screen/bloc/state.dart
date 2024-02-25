part of 'bloc.dart';

// make inbox status enum
enum MentionsStatus {
  initial,
  loading,
  success,
  failure,
}

class MentionsState extends Equatable {
  const MentionsState({
    this.isLoading = false,
    this.mentions = const [],
    this.error,
    this.replyItemsStatus = MentionsStatus.initial,
    this.sortType = LemmyCommentSortType.hot,
    this.showAll = false,
    this.pagesLoaded = 1,
    this.isRefreshing = false,
    this.reachedEnd = false,
  });

  final MentionsStatus replyItemsStatus;
  final bool isLoading;
  final Object? error;
  final List<LemmyInboxMention> mentions;
  final LemmyCommentSortType sortType;
  final bool showAll;
  final int pagesLoaded;
  final bool isRefreshing;
  final bool reachedEnd;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        mentions,
        replyItemsStatus,
        sortType,
        showAll,
        pagesLoaded,
        isRefreshing,
        reachedEnd,
      ];

  MentionsState copyWith({
    bool? isLoading,
    Object? error,
    List<LemmyInboxMention>? mentions,
    MentionsStatus? inboxStatus,
    LemmyCommentSortType? sortType,
    bool? showAll,
    int? pagesLoaded,
    bool? isRefreshing,
    bool? reachedEnd,
  }) {
    return MentionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      mentions: mentions ?? this.mentions,
      replyItemsStatus: inboxStatus ?? replyItemsStatus,
      sortType: sortType ?? this.sortType,
      showAll: showAll ?? this.showAll,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      reachedEnd: reachedEnd ?? this.reachedEnd,
    );
  }
}
