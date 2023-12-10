import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

class InboxMentionsRetriever extends ContentRetriever {
  InboxMentionsRetriever({
    required this.repo,
    this.unreadOnly = false,
    this.sortType = LemmyCommentSortType.latest,
  });

  final LemmyCommentSortType sortType;
  final bool unreadOnly;
  final ServerRepo repo;

  @override
  Future<List<Object>> call({required int page}) {
    return repo.lemmyRepo
        .getMention(page: page, sort: sortType, unreadOnly: unreadOnly);
  }

  InboxMentionsRetriever copyWith({
    LemmyCommentSortType? sortType,
    bool? unreadOnly,
    ServerRepo? repo,
  }) {
    return InboxMentionsRetriever(
      sortType: sortType ?? this.sortType,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      repo: repo ?? this.repo,
    );
  }
}

class InboxRepliesRetriever extends ContentRetriever {
  InboxRepliesRetriever({
    required this.repo,
    this.unreadOnly = false,
    this.sortType = LemmyCommentSortType.latest,
  });

  final LemmyCommentSortType sortType;
  final bool unreadOnly;
  final ServerRepo repo;

  @override
  Future<List<Object>> call({required int page}) {
    return repo.lemmyRepo
        .getReplies(page: page, sort: sortType, unreadOnly: unreadOnly);
  }

  InboxRepliesRetriever copyWith({
    LemmyCommentSortType? sortType,
    bool? unreadOnly,
    ServerRepo? repo,
  }) {
    return InboxRepliesRetriever(
      sortType: sortType ?? this.sortType,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      repo: repo ?? this.repo,
    );
  }
}
