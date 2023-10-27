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
    this.replyItems = const [],
    this.error,
    this.replyItemsStatus = RepliesStatus.initial,
    this.sortType = LemmyCommentSortType.hot,
  });

  final RepliesStatus replyItemsStatus;
  final bool isLoading;
  final Object? error;
  final List<LemmyInboxReply> replyItems;
  final LemmyCommentSortType sortType;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        replyItems,
        replyItemsStatus,
        sortType,
      ];

  RepliesState copyWith({
    bool? isLoading,
    Object? error,
    List<LemmyInboxReply>? replies,
    RepliesStatus? inboxStatus,
    LemmyCommentSortType? sortType,
  }) {
    return RepliesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      replyItems: replies ?? this.replyItems,
      replyItemsStatus: inboxStatus ?? this.replyItemsStatus,
      sortType: sortType ?? this.sortType,
    );
  }
}
