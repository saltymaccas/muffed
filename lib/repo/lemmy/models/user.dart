import 'package:equatable/equatable.dart';

import 'package:muffed/repo/lemmy/models/models.dart';

class LemmyGetPersonDetailsResponse {
  LemmyGetPersonDetailsResponse({
    required this.person,
    required this.posts,
    required this.comments,
    required this.moderates,
  });

  final LemmyUser person;
  final List<LemmyPost> posts;
  final List<LemmyComment> comments;
  final List<String> moderates;
}

class LemmyUser extends Equatable {
  const LemmyUser({
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
    this.moderates,
  });

  factory LemmyUser.fromJson(Map<String, dynamic> json) {
    late final JsonTypes jsonType;

    // gets what type of json was parsed in
    if (json['person_view'] != null) {
      jsonType = JsonTypes.getPersonDetailsResponse;
    } else if (json['person'] != null) {
      jsonType = JsonTypes.personView;
    } else if (json['actor_id'] != null) {
      jsonType = JsonTypes.person;
    } else {
      throw Exception('Json parsed into person does not appear to be a person');
    }

    // extracts the person json depending on what json was parsed in
    late final Map<String, dynamic> person;

    switch (jsonType) {
      case JsonTypes.getPersonDetailsResponse:
        person = json['person_view']['person'];
      case JsonTypes.personView:
        person = json['person'];

      case JsonTypes.person:
        person = json;
      case _:
        throw Exception(
            'Json parsed into person does not appear to be a person',);
    }

    late final Map<String, dynamic>? personView;

    switch (jsonType) {
      case JsonTypes.getPersonDetailsResponse:
        personView = json['person_view'];
      case JsonTypes.personView:
        personView = json;
      case _:
        personView = null;
    }

    late final Map<String, dynamic>? personDetailsResponse;

    switch (jsonType) {
      case JsonTypes.getPersonDetailsResponse:
        personDetailsResponse = json;
      case _:
        personDetailsResponse = null;
    }

    return LemmyUser(
      actorId: person['actor_id'],
      admin: person['admin'],
      banned: person['banned'],
      botAccount: person['bot_account'],
      deleted: person['deleted'],
      id: person['id'],
      instanceId: person['instance_id'],
      local: person['local'],
      name: person['name'],
      published: DateTime.parse(person['published']),
      avatar: person['avatar'],
      banExpires: (person['ban_expires'] != null)
          ? DateTime.parse(person['ban_expires'])
          : null,
      banner: person['banner'],
      bio: person['bio'],
      displayName: person['display_name'],
      matrixUserId: person['matrix_user_id'],
      updated: person['updated'],
      commentCount: personView?['counts']['comment_count'],
      commentScore: personView?['counts']['comment_score'],
      postCount: personView?['counts']['post_count'],
      postScore: personView?['counts']['post_score'],
      moderates: (personDetailsResponse != null)
          ? List.generate(
              personDetailsResponse['moderates'].length,
              (index) => LemmyCommunity.fromJson(
                personDetailsResponse!['moderates'][index]['community'],
              ),
            )
          : null,
    );
  }

  LemmyUser.placeHolder()
      : actorId = 'https://sh.itjust.works/u/muffed',
        admin = false,
        banned = false,
        botAccount = false,
        deleted = false,
        id = 250203,
        instanceId = 1,
        local = true,
        name = 'muffed',
        published = DateTime.parse('2023-09-23T10:20:28.671041'),
        avatar = null,
        banExpires = null,
        banner = null,
        bio = null,
        displayName = null,
        matrixUserId = null,
        updated = null,
        commentCount = null,
        commentScore = null,
        postCount = null,
        postScore = null,
        moderates = [];

  final String actorId;
  final bool? admin;
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

  final List<LemmyCommunity>? moderates;

  bool isFullyLoaded() =>
      commentCount != null &&
      postCount != null &&
      commentScore != null &&
      postScore != null;

  String getTag() {
    final regex = RegExp('https://([^/]+)/u/([^/]+)');
    final match = regex.firstMatch(actorId);
    return '@${match?.group(2)}@${match?.group(1)}';
  }

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
