import 'package:equatable/equatable.dart';

import 'models.dart';

class LemmyCommunity extends Equatable {
  const LemmyCommunity({
    // --- community
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

    // --- community view
    required this.blocked,
    required this.subscribed,
    this.comments,
    this.hotRank,
    this.posts,
    this.subscribers,
    this.usersActiveDay,
    this.usersActiveHalfYear,
    this.usersActiveMonth,
    this.usersActiveWeek,
    this.banner,
    this.description,
    this.icon,
    this.updated,
    // --- get community response
    this.moderators,
  });

  factory LemmyCommunity.fromJson(Map<String, dynamic> json) {
    late final JsonTypes jsonType;

    // gets what type of json was parsed in
    if (json['community_view'] != null) {
      jsonType = JsonTypes.getCommunityResponse;
    } else if (json['community'] != null) {
      jsonType = JsonTypes.communityView;
    } else if (json['actor_id'] != null) {
      jsonType = JsonTypes.community;
    } else {
      throw Exception(
          'Json parsed into community does not appear to be a community');
    }

    late final Map<String, dynamic> community;
    late final Map<String, dynamic>? communityView;
    late final Map<String, dynamic>? getCommunityResponse;

    switch (jsonType) {
      case JsonTypes.getCommunityResponse:
        community = json['community_view']['community'];
        communityView = json['community_view'];
        getCommunityResponse = json;
      case JsonTypes.communityView:
        community = json['community'];
        communityView = json;
        getCommunityResponse = null;
      case JsonTypes.community:
        community = json;
        communityView = null;
        getCommunityResponse = null;
      case _:
        throw Exception(
            'Json parsed into community does not appear to be a community');
    }

    return LemmyCommunity(
      id: community['id'],
      actorId: community['actor_id'],
      deleted: community['deleted'],
      hidden: community['hidden'],
      name: community['name'],
      local: community['local'],
      instanceId: community['instance_id'],
      nsfw: community['nsfw'],
      postingRestrictedToMods: community['posting_restricted_to_mods'],
      published: DateTime.parse(community['published']),
      removed: community['removed'],
      title: community['title'],
      comments: communityView?['counts']['comments'],
      hotRank: communityView?['counts']['hot_rank'],
      posts: communityView?['counts']['posts'],
      subscribers: communityView?['counts']['subscribers'],
      usersActiveDay: communityView?['counts']['users_active_day'],
      usersActiveHalfYear: communityView?['counts']['users_active_half_year'],
      usersActiveMonth: communityView?['counts']['users_active_month'],
      usersActiveWeek: communityView?['counts']['users_active_week'],
      blocked: communityView?['blocked'],
      subscribed: LemmySubscribedType.fromJson(
        communityView?['subscribed'] as String,
      ),
      icon: community['icon'],
      description: community['description'],
      banner: community['banner'],
      updated: community['update'],
      moderators: (getCommunityResponse != null)
          ? List.generate(
              getCommunityResponse['moderators'].length,
              (index) => LemmyUser.fromJson(
                getCommunityResponse?['moderators'][index]['moderator'],
              ),
            )
          : null,
    );
  }

  LemmyCommunity.placeHolder()
      : id = 250203,
        name = 'muffed',
        title = 'muffed for lemmy',
        removed = false,
        published = DateTime.parse('2023-09-23T10:20:28.671041'),
        description = """
An open source Lemmy client written in flutter with a focus on usability and privacy.'

          https://github.com/freshfieldreds/muffed""",
        updated = '2023-10-22T22:44:32.603287',
        deleted = false,
        nsfw = false,
        actorId = 'https://sh.itjust.works/c/muffed',
        local = true,
        hidden = false,
        postingRestrictedToMods = false,
        instanceId = 1,
        moderators = null,
        banner = null,
        icon = null,
        blocked = null,
        subscribed = null,
        comments = null,
        hotRank = null,
        posts = null,
        subscribers = null,
        usersActiveDay = null,
        usersActiveHalfYear = null,
        usersActiveMonth = null,
        usersActiveWeek = null;

  /// from [JsonTypes.community]

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

  /// from [JsonTypes.communityView]

  final bool? blocked;
  final LemmySubscribedType? subscribed;
  final int? comments;
  final int? hotRank;
  final int? posts;
  final int? subscribers;
  final int? usersActiveDay;
  final int? usersActiveHalfYear;
  final int? usersActiveMonth;
  final int? usersActiveWeek;

  /// from [JsonTypes.getCommunityResponse]

  final List<LemmyUser>? moderators;

  String get tag {
    final regex = RegExp('https://([^/]+)/c/([^/]+)');
    final match = regex.firstMatch(actorId);
    return '!${match?.group(2)}@${match?.group(1)}';
  }

  /// Some api calls in lemmy do not return some parameters
  /// so this is here to say whether all the information has been received
  bool get isFullyLoaded => moderators != null;

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
    List<LemmyUser>? moderators,
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
