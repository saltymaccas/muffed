part of 'bloc.dart';

// make inbox status enum
enum InboxStatus {
  initial,
  loading,
  success,
  failure,
}

class InboxState extends Equatable {
  const InboxState({
    this.isLoading = false,
    this.inboxItems = const [],
    this.error,
    this.inboxItemsStatus = InboxStatus.initial,
    this.sortType = LemmyCommentSortType.hot,
  });

  final InboxStatus inboxItemsStatus;
  final bool isLoading;
  final Object? error;
  final List<LemmyComment> inboxItems;
  final LemmyCommentSortType sortType;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        inboxItems,
        inboxItemsStatus,
        sortType,
      ];

  InboxState copyWith({
    bool? isLoading,
    Object? error,
    List<LemmyComment>? replies,
    InboxStatus? inboxStatus,
    LemmyCommentSortType? sortType,
  }) {
    return InboxState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      inboxItems: replies ?? this.inboxItems,
      inboxItemsStatus: inboxStatus ?? this.inboxItemsStatus,
      sortType: sortType ?? this.sortType,
    );
  }
}
