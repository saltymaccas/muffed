import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

class InboxMentionsRetrieverDelegate
    extends ContentRetrieverDelegate<LemmyInboxMention> {
  const InboxMentionsRetrieverDelegate({
    required this.repo,
    this.unreadOnly = false,
    this.sortType = LemmyCommentSortType.latest,
  });

  final LemmyCommentSortType sortType;
  final bool unreadOnly;
  final ServerRepo repo;

  @override
  Future<List<LemmyInboxMention>> retrieveContent({required int page}) {
    return repo.lemmyRepo
        .getMention(page: page, sort: sortType, unreadOnly: unreadOnly);
  }

  InboxMentionsRetrieverDelegate copyWith({
    LemmyCommentSortType? sortType,
    bool? unreadOnly,
    ServerRepo? repo,
  }) {
    return InboxMentionsRetrieverDelegate(
      sortType: sortType ?? this.sortType,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      repo: repo ?? this.repo,
    );
  }

  @override
  List<Object?> get props => [sortType, unreadOnly, repo];
}

class InboxRepliesRetrieverDelegate
    extends ContentRetrieverDelegate<LemmyInboxReply> {
  const InboxRepliesRetrieverDelegate({
    required this.repo,
    this.unreadOnly = false,
    this.sortType = LemmyCommentSortType.latest,
  });

  final LemmyCommentSortType sortType;
  final bool unreadOnly;
  final ServerRepo repo;

  @override
  Future<List<LemmyInboxReply>> retrieveContent({required int page}) {
    return repo.lemmyRepo
        .getReplies(page: page, sort: sortType, unreadOnly: unreadOnly);
  }

  InboxRepliesRetrieverDelegate copyWith({
    LemmyCommentSortType? sortType,
    bool? unreadOnly,
    ServerRepo? repo,
  }) {
    return InboxRepliesRetrieverDelegate(
      sortType: sortType ?? this.sortType,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      repo: repo ?? this.repo,
    );
  }

  @override
  List<Object?> get props => [sortType, unreadOnly, repo];
}
