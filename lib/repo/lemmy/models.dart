import 'package:equatable/equatable.dart';

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

Map<LemmySortType, String> lemmySortTypeToJson = {
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

Map<LemmySearchType, String> lemmySearchTypeToJson = {
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

Map<LemmySubscribedType, String> lemmySubscribedTypeToJson = {
  LemmySubscribedType.subscribed: 'Subscribed',
  LemmySubscribedType.pending: 'Pending',
  LemmySubscribedType.notSubscribed: 'NotSubscribed',
};

Map<String, LemmySubscribedType> jsonToLemmySubscribedType = {
  'Subscribed': LemmySubscribedType.subscribed,
  'Pending': LemmySubscribedType.pending,
  'NotSubscribed': LemmySubscribedType.notSubscribed,
};

enum LemmyListingType { all, local, community, subscribed }

Map<LemmyListingType, String> lemmyListingTypeToJson = {
  LemmyListingType.all: 'All',
  LemmyListingType.community: 'Community',
  LemmyListingType.subscribed: 'Subscribed',
  LemmyListingType.local: 'Local',
};

enum LemmyVoteType { upVote, downVote, none }

Map<LemmyVoteType, int> lemmyVoteTypeJson = {
  LemmyVoteType.upVote: 1,
  LemmyVoteType.none: 0,
  LemmyVoteType.downVote: -1,
};

Map<int, LemmyVoteType> jsonToLemmyVoteType = {
  1: LemmyVoteType.upVote,
  0: LemmyVoteType.none,
  -1: LemmyVoteType.downVote
};

enum LemmyCommentSortType { hot, top, latest, old }

Map<LemmyCommentSortType, String> lemmyCommentSortTypeToJson = {
  LemmyCommentSortType.hot: 'Hot',
  LemmyCommentSortType.top: 'Top',
  LemmyCommentSortType.latest: 'New',
  LemmyCommentSortType.old: 'Old',
};

class LemmyPost extends Equatable {
  /// initialize object
  LemmyPost({
    required this.apId,
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
    this.body,
    this.url,
    this.thumbnailUrl,
    this.myVote = LemmyVoteType.none,
  });

  LemmyPost.fromPostViewJson(Map<String, dynamic> json)
      : body = json['post']['body'],
        url = json['post']['url'],
        id = json['post']['id'],
        apId = json['post']['ap_id'],
        name = json['post']['name'],
        // Z added to mark as UTC time
        timePublished = DateTime.parse(json['post']['published'] + 'Z'),
        myVote = jsonToLemmyVoteType[json['my_vote']] ?? LemmyVoteType.none,
        thumbnailUrl = json['post']['thumbnail_url'],
        nsfw = json['post']['nsfw'],
        creatorId = json['post']['creator_id'],
        creatorName = json['creator']['name'],
        communityId = json['post']['community_id'],
        communityName = json['community']['name'],
        communityIcon = json['community']['icon'],
        commentCount = json['counts']['comments'],
        upVotes = json['counts']['upvotes'],
        downVotes = json['counts']['downvotes'],
        score = json['counts']['score'],
        read = json['read'],
        saved = json['saved'];

  final int id;
  final String name;

  /// the server address of where the post came from
  /// to get the comments of a post the server address is required
  final String apId;

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

  // not set to final because the user can change these
  int upVotes;
  int downVotes;
  int score;
  LemmyVoteType myVote;

  final bool read;
  final bool saved;

  @override
  List<Object> get props => [apId];
}

class LemmyComment extends Equatable {
  /// initialise object
  LemmyComment({
    this.replies = const [],
    required this.path,
    required this.creatorName,
    required this.creatorId,
    required this.content,
    required this.timePublished,
    required this.id,
    required this.postId,
    required this.childCount,
    required this.upVotes,
    required this.downVotes,
    this.myVote = LemmyVoteType.none,
    required this.score,
    required this.hotRank,
  });

  LemmyComment.fromCommentViewJson(Map<String, dynamic> json)
      : path = (json['comment']['path'] as String)
            .split('.')
            .map(int.parse)
            .toList()
          ..removeLast()
          ..removeAt(0),
        creatorName = json['creator']['name'],
        creatorId = json['creator']['id'],
        content = json['comment']['content'],
        id = json['comment']['id'],
        // Z added to mark as UTC time
        timePublished = DateTime.parse(json['comment']['published'] + 'Z'),
        postId = json['comment']['post_id'],
        childCount = json['counts']['child_count'],
        upVotes = json['counts']['upvotes'],
        downVotes = json['counts']['downvotes'],
        score = json['counts']['score'],
        myVote = jsonToLemmyVoteType[json['my_vote']] ?? LemmyVoteType.none,
        hotRank = json['counts']['hot_rank'],
        replies = [];

  /// Holds the id's of the parent and ancestor comments
  ///
  /// This does not include id of the post or the comment itself.
  final List<int> path;

  List<LemmyComment> replies;
  final String creatorName;
  final String content;
  final DateTime timePublished;
  final int id;
  final int postId;
  final int creatorId;
  final int childCount;

  int upVotes;
  int downVotes;
  int score;
  LemmyVoteType myVote;

  final int hotRank;

  @override
  List<Object?> get props => ['LemmyComment', id];

  /// Gets the number of children that have not been loaded not including grand
  /// children
  int getNumOfUnloadedReplies() {
    int numOfUnloadedChildren = childCount - replies.length;

    for (final reply in replies) {
      numOfUnloadedChildren =
          numOfUnloadedChildren - reply.getNumOfUnloadedReplies();
    }

    return numOfUnloadedChildren;
  }

  /// gets all the number of all the children including nested children
  int getNumberOfReplies() {
    int numberOfReplies = 0;

    for (final reply in replies) {
      numberOfReplies++;
      numberOfReplies = numberOfReplies + reply.getNumberOfReplies();
    }

    return numberOfReplies;
  }

  /// Tries to add the comment into the tree will return true if success and
  /// false if failed
  bool addCommentToTree(LemmyComment comment) {
    if (!comment.path.contains(id)) {
      return false;
    }

    if (comment.path.last == id) {
      replies = {...replies, comment}.toList();
      return true;
    }

    for (final reply in replies) {
      final bool value = reply.addCommentToTree(comment);

      if (value) {
        return true;
      }
    }
    return false;
  }
}

class LemmyCommunity extends Equatable {
  LemmyCommunity({
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

  LemmyCommunity.fromCommunityViewJson(Map<String, dynamic> json)
      : id = json['community']['id'],
        actorId = json['community']['actor_id'],
        deleted = json['community']['deleted'],
        hidden = json['community']['hidden'],
        name = json['community']['name'],
        local = json['community']['local'],
        instanceId = json['community']['instance_id'],
        nsfw = json['community']['nsfw'],
        postingRestrictedToMods =
            json['community']['posting_restricted_to_mods'],
        published = DateTime.parse(json['community']['published'] + 'Z'),
        removed = json['community']['removed'],
        title = json['community']['title'],
        comments = json['counts']['comments'],
        hotRank = json['counts']['hot_rank'],
        posts = json['counts']['posts'],
        subscribers = json['counts']['subscribers'],
        usersActiveDay = json['counts']['users_active_day'],
        usersActiveHalfYear = json['counts']['users_active_half_year'],
        usersActiveMonth = json['counts']['users_active_month'],
        usersActiveWeek = json['counts']['users_active_week'],
        blocked = json['blocked'],
        subscribed = jsonToLemmySubscribedType[json['subscribed']]!,
        icon = json['community']['icon'],
        description = json['community']['description'],
        banner = json['community']['banner'],
        updated = json['community']['update'];

  @override
  List<Object?> get props => ['LemmyCommunity', id];
}

class LemmyPerson extends Equatable {
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

  LemmyPerson.fromPersonViewJson(Map<String, dynamic> json)
      : actorId = json['person']['actor_id'],
        admin = json['person']['admin'],
        banned = json['person']['banned'],
        botAccount = json['person']['bot_account'],
        deleted = json['person']['deleted'],
        id = json['person']['id'],
        instanceId = json['person']['instance_id'],
        local = json['person']['local'],
        name = json['person']['name'],
        published = DateTime.parse(json['person']['published'] + 'Z'),
        commentCount = json['counts']['comment_count'],
        commentScore = json['counts']['comment_score'],
        postCount = json['counts']['post_count'],
        postScore = json['counts']['post_score'],
        avatar = json['person']['avatar'],
        banExpires = json['person']['ban_expires'],
        banner = json['person']['banner'],
        bio = json['person']['bio'],
        displayName = json['person']['display_name'],
        matrixUserId = json['person']['matrix_user_id'],
        updated = json['person']['updated'];

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

  @override
  List<Object?> get props => ['LemmyPerson', id];
}

class LemmyGetPersonDetailsResponse {
  LemmyGetPersonDetailsResponse({
    required this.person,
    required this.posts,
    required this.comments,
    required this.moderates,
  });

  final LemmyPerson person;
  final List<LemmyPost> posts;
  final List<LemmyComment> comments;

  final List<String> moderates;
}

class LemmySearchResponse {
  LemmySearchResponse({
    this.lemmyComments,
    this.lemmyCommunities,
    this.lemmyPersons,
    this.lemmyPosts,
  });

  final List<LemmyPost>? lemmyPosts;
  final List<LemmyCommunity>? lemmyCommunities;
  final List<LemmyComment>? lemmyComments;
  final List<LemmyPerson>? lemmyPersons;
}

class LemmyLoginResponse {
  LemmyLoginResponse({
    this.jwt,
    required this.registrationCreated,
    required this.verifyEmailSent,
  });

  final String? jwt;
  final bool registrationCreated;
  final bool verifyEmailSent;
}
