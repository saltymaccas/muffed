part of 'bloc.dart';

sealed class PostPageEvent {}

final class InitializeEvent extends PostPageEvent {}

final class ReachedNearEndOfScroll extends PostPageEvent {}

final class UserCommented extends PostPageEvent {
  UserCommented({
    required this.comment,
    required this.onSuccess,
    required this.onError,
  });

  final void Function() onSuccess;
  final void Function() onError;
  final String comment;
}

final class UserRepliedToComment extends PostPageEvent {
  UserRepliedToComment({
    required this.onSuccess,
    required this.onError,
    required this.comment,
    required this.commentId,
  });

  final void Function() onSuccess;
  final void Function() onError;
  final int commentId;
  final String comment;
}

final class PullDownRefresh extends PostPageEvent {}

final class SortTypeChanged extends PostPageEvent {
  SortTypeChanged(this.sortType);

  final LemmyCommentSortType sortType;
}

final class LoadMoreRepliesPressed extends PostPageEvent {
  LoadMoreRepliesPressed({required this.id});

  final int id;
}
