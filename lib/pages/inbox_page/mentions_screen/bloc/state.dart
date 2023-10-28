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
  });

  final MentionsStatus replyItemsStatus;
  final bool isLoading;
  final Object? error;
  final List<LemmyInboxMention> mentions;
  final LemmyCommentSortType sortType;
  final bool showAll;
  final int pagesLoaded;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        mentions,
        replyItemsStatus,
        sortType,
        showAll,
        pagesLoaded,
      ];

  MentionsState copyWith({
    bool? isLoading,
    Object? error,
    List<LemmyInboxMention>? mentions,
    MentionsStatus? inboxStatus,
    LemmyCommentSortType? sortType,
    bool? showAll,
    int? pagesLoaded,
  }) {
    return MentionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      mentions: mentions ?? this.mentions,
      replyItemsStatus: inboxStatus ?? this.replyItemsStatus,
      sortType: sortType ?? this.sortType,
      showAll: showAll ?? this.showAll,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
    );
  }
}
