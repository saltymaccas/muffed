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
  LemmySortType.topMonth: 'TopMonth',
  LemmySortType.topYear: 'TopYear',
  LemmySortType.topAll: 'TopAll',
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
  -1: LemmyVoteType.downVote,
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
  const LemmyPost({
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

  /// Activity pub id
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

  final int upVotes;
  final int downVotes;
  final int score;
  final LemmyVoteType myVote;

  final bool read;
  final bool saved;

  @override
  List<Object?> get props => [
        id,
        name,
        apId,
        url,
        thumbnailUrl,
        body,
        timePublished,
        nsfw,
        creatorId,
        creatorName,
        communityId,
        communityName,
        communityIcon,
        commentCount,
        upVotes,
        downVotes,
        score,
        myVote,
        read,
        saved,
      ];

  LemmyPost copyWith({
    int? id,
    String? name,
    String? apId,
    String? url,
    String? thumbnailUrl,
    String? body,
    DateTime? timePublished,
    bool? nsfw,
    int? creatorId,
    String? creatorName,
    int? communityId,
    String? communityName,
    String? communityIcon,
    int? commentCount,
    int? upVotes,
    int? downVotes,
    int? score,
    LemmyVoteType? myVote,
    bool? read,
    bool? saved,
  }) {
    return LemmyPost(
      id: id ?? this.id,
      name: name ?? this.name,
      apId: apId ?? this.apId,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      body: body ?? this.body,
      timePublished: timePublished ?? this.timePublished,
      nsfw: nsfw ?? this.nsfw,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      communityId: communityId ?? this.communityId,
      communityName: communityName ?? this.communityName,
      communityIcon: communityIcon ?? this.communityIcon,
      commentCount: commentCount ?? this.commentCount,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      score: score ?? this.score,
      myVote: myVote ?? this.myVote,
      read: read ?? this.read,
      saved: saved ?? this.saved,
    );
  }
}

class LemmyComment extends Equatable {
  /// initialise object
  const LemmyComment({
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
    required this.score,
    required this.hotRank,
    required this.postTitle,
    required this.communityName,
    required this.communityId,
    required this.postCreatorId,
    this.myVote = LemmyVoteType.none,
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
        postTitle = json['post']['name'],
        communityName = json['community']['name'],
        communityId = json['community']['id'],
        postCreatorId = json['post']['creator_id'];

  /// Holds the id's of the parent and ancestor comments
  ///
  /// This does not include id of the post or the comment itself.
  final List<int> path;

  final int postCreatorId;
  final String postTitle;
  final String communityName;
  final int communityId;
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
  final LemmyVoteType myVote;

  final int hotRank;

  int getLevel() => path.length;

  @override
  List<Object?> get props => [
        path,
        creatorName,
        content,
        timePublished,
        id,
        postId,
        creatorId,
        childCount,
        upVotes,
        downVotes,
        score,
        myVote,
        hotRank,
        postTitle,
        communityName,
        communityId,
        postCreatorId,
      ];

  LemmyComment copyWith({
    List<int>? path,
    String? creatorName,
    String? content,
    DateTime? timePublished,
    int? id,
    int? postId,
    int? creatorId,
    int? childCount,
    int? upVotes,
    int? downVotes,
    int? score,
    LemmyVoteType? myVote,
    int? hotRank,
    String? postTitle,
    String? communityName,
    int? communityId,
    int? postCreatorId,
  }) {
    return LemmyComment(
      path: path ?? this.path,
      creatorName: creatorName ?? this.creatorName,
      content: content ?? this.content,
      timePublished: timePublished ?? this.timePublished,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      creatorId: creatorId ?? this.creatorId,
      childCount: childCount ?? this.childCount,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      score: score ?? this.score,
      myVote: myVote ?? this.myVote,
      hotRank: hotRank ?? this.hotRank,
      postTitle: postTitle ?? this.postTitle,
      communityName: communityName ?? this.communityName,
      communityId: communityId ?? this.communityId,
      postCreatorId: postCreatorId ?? this.postCreatorId,
    );
  }
}

class LemmyInboxReply extends Equatable {
  const LemmyInboxReply({
    required this.comment,
    required this.read,
    required this.id,
  });

  LemmyInboxReply.fromReplyViewJson(Map<String, dynamic> json)
      : comment = LemmyComment.fromCommentViewJson(json),
        read = json['comment_reply']['read'],
        id = json['comment_reply']['id'];

  final LemmyComment comment;
  final bool read;
  final int id;

  LemmyInboxReply copyWith({
    LemmyComment? comment,
    bool? read,
    int? id,
  }) {
    return LemmyInboxReply(
      comment: comment ?? this.comment,
      read: read ?? this.read,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [comment, read];
}

class LemmyInboxMention extends Equatable {
  const LemmyInboxMention({
    required this.comment,
    required this.read,
    required this.id,
  });

  LemmyInboxMention.fromPersonMentionViewJson(Map<String, dynamic> json)
      : comment = LemmyComment.fromCommentViewJson(json),
        read = json['person_mention']['read'],
        id = json['person_mention']['id'];

  final LemmyComment comment;
  final bool read;
  final int id;

  @override
  List<Object?> get props => [comment, read];

  LemmyInboxMention copyWith({
    LemmyComment? comment,
    bool? read,
    int? id,
  }) {
    return LemmyInboxMention(
      comment: comment ?? this.comment,
      read: read ?? this.read,
      id: id ?? this.id,
    );
  }
}

class LemmyCommunity extends Equatable {
  const LemmyCommunity({
    required this.id,
    required this.actorId,
    required this.deleted,
    required this.hidden,
    required this.name,
    required this.local,
    required this.instanceId,
    required this.nsfw,
    required this.postingRestrictedToMods,
    required this.published,
    required this.removed,
    required this.title,
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
    this.banner,
    this.description,
    this.icon,
    this.updated,
    this.moderators,
  });

  factory LemmyCommunity.fromJson(Map<String, dynamic> json) {
    // works out what json type was parsed in
    final isCommunityResponse = json['community_view'] != null;
    final Map<String, dynamic> communityView =
        isCommunityResponse ? json['community_view'] : json;
    final Map<String, dynamic>? communityResponse =
        isCommunityResponse ? json : null;

    return LemmyCommunity(
      id: communityView['community']['id'],
      actorId: communityView['community']['actor_id'],
      deleted: communityView['community']['deleted'],
      hidden: communityView['community']['hidden'],
      name: communityView['community']['name'],
      local: communityView['community']['local'],
      instanceId: communityView['community']['instance_id'],
      nsfw: communityView['community']['nsfw'],
      postingRestrictedToMods: communityView['community']
          ['posting_restricted_to_mods'],
      published: DateTime.parse(communityView['community']['published'] + 'Z'),
      removed: communityView['community']['removed'],
      title: communityView['community']['title'],
      comments: communityView['counts']['comments'],
      hotRank: communityView['counts']['hot_rank'],
      posts: communityView['counts']['posts'],
      subscribers: communityView['counts']['subscribers'],
      usersActiveDay: communityView['counts']['users_active_day'],
      usersActiveHalfYear: communityView['counts']['users_active_half_year'],
      usersActiveMonth: communityView['counts']['users_active_month'],
      usersActiveWeek: communityView['counts']['users_active_week'],
      blocked: communityView['blocked'],
      subscribed: jsonToLemmySubscribedType[communityView['subscribed']]!,
      icon: communityView['community']['icon'],
      description: communityView['community']['description'],
      banner: communityView['community']['banner'],
      updated: communityView['community']['update'],
      moderators: (communityResponse != null)
          ? List.generate(
              communityResponse['moderators'].length,
              (index) => LemmyPerson.fromPersonViewJson(
                communityResponse['moderators'][index]['moderator'],
              ),
            )
          : null,
    );
  }

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

  final List<LemmyPerson>? moderators;

  String getTag() {
    final regex = RegExp('https://([^/]+)/c/([^/]+)');
    final match = regex.firstMatch(actorId);
    return '!${match?.group(2)}@${match?.group(1)}';
  }

  /// Some api calls in lemmy do not return some parameters
  /// so this is here to say whether all the information has been received
  bool isFullyLoaded() => moderators != null;

  @override
  List<Object?> get props => [
        id,
        actorId,
        banner,
        deleted,
        description,
        hidden,
        icon,
        name,
        local,
        instanceId,
        nsfw,
        postingRestrictedToMods,
        published,
        removed,
        title,
        updated,
        comments,
        hotRank,
        posts,
        subscribers,
        usersActiveDay,
        usersActiveHalfYear,
        usersActiveMonth,
        usersActiveWeek,
        blocked,
        subscribed,
        moderators,
      ];

  LemmyCommunity copyWith({
    int? id,
    String? actorId,
    String? banner,
    bool? deleted,
    String? description,
    bool? hidden,
    String? icon,
    String? name,
    bool? local,
    int? instanceId,
    bool? nsfw,
    bool? postingRestrictedToMods,
    DateTime? published,
    bool? removed,
    String? title,
    String? updated,
    int? comments,
    int? hotRank,
    int? posts,
    int? subscribers,
    int? usersActiveDay,
    int? usersActiveHalfYear,
    int? usersActiveMonth,
    int? usersActiveWeek,
    bool? blocked,
    LemmySubscribedType? subscribed,
    List<LemmyPerson>? moderators,
  }) {
    return LemmyCommunity(
      id: id ?? this.id,
      actorId: actorId ?? this.actorId,
      banner: banner ?? this.banner,
      deleted: deleted ?? this.deleted,
      description: description ?? this.description,
      hidden: hidden ?? this.hidden,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      local: local ?? this.local,
      instanceId: instanceId ?? this.instanceId,
      nsfw: nsfw ?? this.nsfw,
      postingRestrictedToMods:
          postingRestrictedToMods ?? this.postingRestrictedToMods,
      published: published ?? this.published,
      removed: removed ?? this.removed,
      title: title ?? this.title,
      updated: updated ?? this.updated,
      comments: comments ?? this.comments,
      hotRank: hotRank ?? this.hotRank,
      posts: posts ?? this.posts,
      subscribers: subscribers ?? this.subscribers,
      usersActiveDay: usersActiveDay ?? this.usersActiveDay,
      usersActiveHalfYear: usersActiveHalfYear ?? this.usersActiveHalfYear,
      usersActiveMonth: usersActiveMonth ?? this.usersActiveMonth,
      usersActiveWeek: usersActiveWeek ?? this.usersActiveWeek,
      blocked: blocked ?? this.blocked,
      subscribed: subscribed ?? this.subscribed,
      moderators: moderators ?? this.moderators,
    );
  }
}

class LemmyPerson extends Equatable {
  const LemmyPerson({
    required this.actorId,
    required this.admin,
    required this.banned,
    required this.botAccount,
    required this.deleted,
    required this.id,
    required this.instanceId,
    required this.local,
    required this.name,
    required this.published,
    this.commentCount,
    this.commentScore,
    this.postCount,
    this.postScore,
    this.avatar,
    this.banExpires,
    this.banner,
    this.bio,
    this.displayName,
    this.matrixUserId,
    this.updated,
  });

  factory LemmyPerson.fromPersonViewJson(Map<String, dynamic> json) {
    final isPersonView = json['person'] != null;
    final person = isPersonView ? json['person'] : json;
    final personView = isPersonView ? json : null;

    return LemmyPerson(
      actorId: person['actor_id'],
      admin: person['admin'],
      banned: person['banned'],
      botAccount: person['bot_account'],
      deleted: person['deleted'],
      id: person['id'],
      instanceId: person['instance_id'],
      local: person['local'],
      name: person['name'],
      published: DateTime.parse(person['published'] + 'Z'),
      avatar: person['avatar'],
      banExpires: (person['ban_expires'] != null)
          ? DateTime.parse(person['ban_expires'] + 'Z')
          : null,
      banner: person['banner'],
      bio: person['bio'],
      displayName: person['display_name'],
      matrixUserId: person['matrix_user_id'],
      updated: person['updated'],
      commentCount:
          (personView != null) ? personView['counts']['comment_count'] : null,
      commentScore:
          (personView != null) ? personView['counts']['comment_score'] : null,
      postCount:
          (personView != null) ? personView['counts']['post_count'] : null,
      postScore:
          (personView != null) ? personView['counts']['post_score'] : null,
    );
  }

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

  final int? commentCount;
  final int? commentScore;
  final int? postCount;
  final int? postScore;

  bool isFullyLoaded() =>
      commentCount != null &&
      postCount != null &&
      commentScore != null &&
      postScore != null;

  @override
  List<Object?> get props => [
        actorId,
        admin,
        avatar,
        banExpires,
        banned,
        banner,
        bio,
        botAccount,
        deleted,
        displayName,
        id,
        instanceId,
        local,
        matrixUserId,
        name,
        published,
        updated,
        commentCount,
        commentScore,
        postCount,
        postScore,
      ];
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
    required this.registrationCreated,
    required this.verifyEmailSent,
    this.jwt,
  });

  final String? jwt;
  final bool registrationCreated;
  final bool verifyEmailSent;
}

class LemmySite extends Equatable {
  const LemmySite({
    required this.admins,
    required this.languages,
    required this.discussionLanguages,
    required this.version,
    required this.id,
    required this.instanceId,
    required this.name,
    required this.published,
    this.banner,
    this.description,
    this.icon,
    this.privateKey,
    this.publicKey,
    this.sidebar,
    this.updated,
  });

  LemmySite.fromGetSiteResponse(Map<String, dynamic> json)
      : admins = List.generate(
          json['admins'].length,
          (index) => LemmyPerson.fromPersonViewJson(json['admins'][index]),
        ),
        languages = List.generate(
          json['all_languages'].length,
          (index) => LemmyLanguage.fromLanguage(json['all_languages'][index]),
        ),
        discussionLanguages = List.generate(
          json['discussion_languages'].length,
          (index) => json['discussion_languages'][index],
        ),
        version = json['version'],
        banner = json['site_view']['site']['banner'],
        description = json['site_view']['site']['description'],
        icon = json['site_view']['site']['icon'],
        id = json['site_view']['site']['id'],
        instanceId = json['site_view']['site']['instance_id'],
        name = json['site_view']['site']['name'],
        privateKey = json['site_view']['site']['private_key'],
        publicKey = json['site_view']['site']['public_key'],
        published =
            DateTime.parse('${json['site_view']['site']['published']}Z'),
        sidebar = json['site_view']['site']['sidebar'],
        updated = DateTime.parse('${json['site_view']['site']['updated']}Z');

  final List<LemmyPerson> admins;
  final List<LemmyLanguage> languages;
  final List<int> discussionLanguages;
  final String version;

  // site
  final String? banner;
  final String? description;
  final String? icon;
  final int id;
  final int instanceId;
  final String name;
  final String? privateKey;
  final String? publicKey;
  final DateTime published;
  final String? sidebar;
  final DateTime? updated;

  @override
  List<Object?> get props => [
        admins,
        languages,
        discussionLanguages,
        version,
        banner,
        description,
        icon,
        id,
        instanceId,
        name,
        privateKey,
        publicKey,
        published,
        sidebar,
        updated,
      ];
}

class LemmyLanguage extends Equatable {
  const LemmyLanguage({
    required this.code,
    required this.id,
    required this.name,
  });

  LemmyLanguage.fromLanguage(Map<String, dynamic> json)
      : code = json['code'],
        id = json['id'],
        name = json['name'];

  final String code;
  final int id;
  final String name;

  @override
  List<Object?> get props => [
        code,
        id,
        name,
      ];
}
