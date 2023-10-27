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
    this.replyItems = const [],
    this.error,
    this.replyItemsStatus = MentionsStatus.initial,
    this.sortType = LemmyCommentSortType.hot,
  });

  final MentionsStatus replyItemsStatus;
  final bool isLoading;
  final Object? error;
  final List<LemmyComment> replyItems;
  final LemmyCommentSortType sortType;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        replyItems,
        replyItemsStatus,
        sortType,
      ];

  MentionsState copyWith({
    bool? isLoading,
    Object? error,
    List<LemmyComment>? replies,
    MentionsStatus? inboxStatus,
    LemmyCommentSortType? sortType,
  }) {
    return MentionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      replyItems: replies ?? this.replyItems,
      replyItemsStatus: inboxStatus ?? this.replyItemsStatus,
      sortType: sortType ?? this.sortType,
    );
  }
}
