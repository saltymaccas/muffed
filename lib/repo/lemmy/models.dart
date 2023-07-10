import 'package:equatable/equatable.dart';

enum ContentType {
  text,
  image,
  video,
  gif,
  url,
}

enum LemmySortType {
  active,
  hot,
  latest,
  old,
  topDay,
  topWeek,
  topMonth,
  topYear,
  topAll,
  mostComments,
  newComments,
  topHour,
  topSixHour,
  topTwelveHour,
}

Map<LemmySortType, String> lemmySortTypeEnumToApiCompatible = {
  LemmySortType.active: 'Active',
  LemmySortType.hot: 'Hot',
  LemmySortType.latest: 'New',
  LemmySortType.old: 'Old',
  LemmySortType.topDay: 'TopDay',
  LemmySortType.topWeek: 'TopWeek',
  LemmySortType.topMonth: "TopMonth",
  LemmySortType.topYear: "TopYear",
  LemmySortType.topAll: "TopAll",
  LemmySortType.mostComments: 'MostComments',
  LemmySortType.newComments: 'NewComments',
  LemmySortType.topHour: 'TopHour',
  LemmySortType.topSixHour: 'TopSixHour',
  LemmySortType.topTwelveHour: 'TopTwelveHour',
};

class LemmyPost extends Equatable {
  final int id;
  final String name;

  final String? url;
  final String? thumbnailUrl;
  final String? body;

  final DateTime timePublished;
  final bool nsfw;

  final int creatorId;
  final String creatorName;

  final int communityId;
  final String communityName;
  final String? communityIcon;

  final int commentCount;
  final int upVotes;
  final int downVotes;
  final int score;

  final bool read;
  final bool saved;

  const LemmyPost({
    this.body,
    this.url,
    this.thumbnailUrl,
    required this.id,
    required this.name,
    required this.timePublished,
    required this.nsfw,
    required this.creatorId,
    required this.creatorName,
    required this.communityId,
    required this.communityName,
    required this.communityIcon,
    required this.commentCount,
    required this.upVotes,
    required this.downVotes,
    required this.score,
    required this.read,
    required this.saved,
  });

  @override
  List<Object> get props => [id];
}

class LemmyComment extends Equatable {
  /// Level that the comment is on where 0 is comment on a post,
  /// 1 is comment on a comment,
  /// 2 in comment on that comment that is on a comment and so on.
  final int level;
  final int? parentId; // The parent comment
  final List<LemmyComment> replies;
  final String creatorName;
  final String content;
  final DateTime timePublished;
  final int id;
  final int postId;
  final int creatorId;
  final int childCount;
  final int upVotes;
  final int downVotes;
  final int score;
  final int hotRank;

  const LemmyComment({
    this.replies = const [],
    this.parentId,
    this.level = 0,
    required this.creatorName,
    required this.creatorId,
    required this.content,
    required this.timePublished,
    required this.id,
    required this.postId,
    required this.childCount,
    required this.upVotes,
    required this.downVotes,
    required this.score,
    required this.hotRank,
  });

  @override
  List<Object?> get props => [id];
}

class LemmyCommentTree {
  LemmyComment comment;
  List<LemmyCommentTree> commentTree;
  int level;

  LemmyCommentTree({
    required this.comment,
    this.commentTree = const [],
    this.level = 0,
  });
}

