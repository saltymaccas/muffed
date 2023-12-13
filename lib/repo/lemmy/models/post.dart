import 'package:equatable/equatable.dart';

import 'models.dart';

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
        timePublished = DateTime.parse(json['post']['published']),
        myVote = LemmyVoteType.fromJson(json['my_vote'] as int?),
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

  LemmyPost.placeHolder()
      : id = 213,
        name = 'placeholder',
        body = '''
      Lorem ipsum dolor sit amet. 
      Sed autem consectetur et assumenda 
      voluptas ut expedita recusandae ad excepturi incidunt ut repellendus 
      itaque. Et sunt totam qui consequatur quisquam eum aliquam placeat.''',
        creatorId = 123,
        communityId = 123,
        nsfw = false,
        thumbnailUrl = null,
        url = null,
        score = 123,
        communityName = 'placeholder',
        creatorName = 'placeholder',
        read = false,
        saved = false,
        apId = 'placeholder',
        timePublished = DateTime.parse('2023-09-23T10:20:28.671041'),
        commentCount = 21,
        downVotes = 11,
        upVotes = 11,
        myVote = LemmyVoteType.none,
        communityIcon = null;

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
