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

enum LemmySearchType {
  all,
  comments,
  posts,
  communities,
  users,
  url,
}

Map<LemmySearchType, String> lemmySearchTypeToApiCompatible = {
  LemmySearchType.all: 'All',
  LemmySearchType.comments: 'Comments',
  LemmySearchType.posts: 'Posts',
  LemmySearchType.communities: 'Communities',
  LemmySearchType.users: 'Users',
  LemmySearchType.url: 'Url',
};

enum LemmySubscribedType {
  subscribed,
  notSubscribed,
  pending,
}

Map<LemmySubscribedType, String> lemmySubscribedTypeToApiCompatible = {
  LemmySubscribedType.subscribed: 'Subscribed',
  LemmySubscribedType.pending: 'Pending',
  LemmySubscribedType.notSubscribed: 'NotSubscribed',
};

Map<String, LemmySubscribedType> apiCompatibleToLemmySubscribedType = {
  'Subscribed': LemmySubscribedType.subscribed,
  'Pending': LemmySubscribedType.pending,
  'NotSubscribed': LemmySubscribedType.notSubscribed,
};

enum LemmyListingType { all, local, community, subscribed }

Map<LemmyListingType, String> lemmyListingTypeToApiCompatible = {
  LemmyListingType.all: 'All',
  LemmyListingType.community: 'Community',
  LemmyListingType.subscribed: 'Subscribed',
  LemmyListingType.local: 'local',
};

enum LemmyVoteType {upVote, downVote, none}

Map<LemmyVoteType, int> lemmyVoteTypeToApiCompatible = {
  LemmyVoteType.upVote: 1,
  LemmyVoteType.none: 0,
  LemmyVoteType.downVote: -1,
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
  final int? myVote;

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
    this.myVote,
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
  final int? parentCommentId; // The parent comment
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
    this.parentCommentId,
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

class LemmyCommunity extends Equatable {
  final int id;
  final String actorId;
  final String? banner;
  final bool deleted;
  final String? description;
  final bool hidden;
  final String? icon;
  final String name;
  final bool local;
  final int instanceId;
  final bool nsfw;
  final bool postingRestrictedToMods;
  final DateTime published;
  final bool removed;
  final String title;
  final String? updated;
  final List<LemmyPerson>? moderators;

  final int comments;
  final int hotRank;
  final int posts;
  final int subscribers;
  final int usersActiveDay;
  final int usersActiveHalfYear;
  final int usersActiveMonth;
  final int usersActiveWeek;

  final bool blocked;

  final LemmySubscribedType subscribed;

  LemmyCommunity({
    this.moderators,
    required this.id,
    required this.actorId,
    this.banner,
    required this.deleted,
    this.description,
    required this.hidden,
    this.icon,
    required this.name,
    required this.local,
    required this.instanceId,
    required this.nsfw,
    required this.postingRestrictedToMods,
    required this.published,
    required this.removed,
    required this.title,
    this.updated,
    required this.comments,
    required this.hotRank,
    required this.posts,
    required this.subscribers,
    required this.usersActiveDay,
    required this.usersActiveHalfYear,
    required this.usersActiveMonth,
    required this.usersActiveWeek,
    required this.blocked,
    required this.subscribed,
  });

  @override
  List<Object?> get props => [id];
}

class LemmyPerson extends Equatable {
  final String actorId;
  final bool admin;
  final String? avatar;
  final DateTime? banExpires;
  final bool banned;
  final String? banner;
  final String? bio;
  final bool botAccount;
  final bool deleted;
  final String? displayName;
  final int id;
  final int instanceId;
  final bool local;
  final String? matrixUserId;
  final String name;
  final DateTime published;
  final String? updated;

  final int commentCount;
  final int commentScore;
  final int postCount;
  final int postScore;

  LemmyPerson({
    required this.actorId,
    required this.admin,
    this.avatar,
    this.banExpires,
    required this.banned,
    this.banner,
    this.bio,
    required this.botAccount,
    required this.deleted,
    this.displayName,
    required this.id,
    required this.instanceId,
    required this.local,
    this.matrixUserId,
    required this.name,
    required this.published,
    this.updated,
    required this.commentCount,
    required this.commentScore,
    required this.postCount,
    required this.postScore,
  });

  @override
  List<Object?> get props => [id];
}

class LemmySearchResponse {
  final List<LemmyPost>? lemmyPosts;
  final List<LemmyCommunity>? lemmyCommunities;
  final List<LemmyComment>? lemmyComments;
  final List<LemmyPerson>? lemmyPersons;

  LemmySearchResponse({
    this.lemmyComments,
    this.lemmyCommunities,
    this.lemmyPersons,
    this.lemmyPosts,
  });
}

class LemmyLoginResponse {
  final String? jwt;
  final bool registrationCreated;
  final bool verifyEmailSent;

  LemmyLoginResponse({
    this.jwt,
    required this.registrationCreated,
    required this.verifyEmailSent,
  });
}
