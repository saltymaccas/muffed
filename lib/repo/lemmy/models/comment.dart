import 'package:equatable/equatable.dart';
import 'package:muffed/repo/lemmy/models/models.dart';

class CommentPlateau extends Equatable {
  const CommentPlateau({
    required this.comment,
    required this.children,
  });

  final LemmyComment comment;
  final List<LemmyComment> children;

  @override
  List<Object?> get props => [comment, children];
}

extension ToCommentPlateau on List<LemmyComment> {}

/// Organizes the comment into tree structure.
///
/// gets every comment on the same level as [level] and places them into the key
/// and puts all of its descendants into the value
List<CommentPlateau> organiseCommentsWithChildren(
  int level,
  List<LemmyComment> comments,
) {
  final List<CommentPlateau> commentPlateau = [];

  for (final comment in comments) {
    if (comment.level == level) {
      final List<LemmyComment> children = [];

      for (final child in comments) {
        if (child.path.contains(comment.id)) {
          children.add(child);
        }
      }

      commentPlateau.add(
        CommentPlateau(
          comment: comment,
          children: children,
        ),
      );
    }
  }

  return commentPlateau;
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
    required this.postTitle,
    required this.communityName,
    required this.communityId,
    required this.postCreatorId,
    this.hotRank,
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
        timePublished = DateTime.parse(json['comment']['published']),
        postId = json['comment']['post_id'],
        childCount = json['counts']['child_count'],
        upVotes = json['counts']['upvotes'],
        downVotes = json['counts']['downvotes'],
        score = json['counts']['score'],
        myVote = LemmyVoteType.fromJson(json['my_vote'] as int?),
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

  // TODO: see if still in api, bc the api seems to not return it
  final int? hotRank;

  int get level => path.length;

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
