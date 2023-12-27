import 'package:equatable/equatable.dart';

import 'package:muffed/repo/lemmy/models/models.dart';

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
  List<Object?> get props => [comment, read, id];
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
  List<Object?> get props => [comment, read, id];

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
