part of 'bloc.dart';

sealed class CreateCommentEvent {}

class Submitted extends CreateCommentEvent {
  Submitted(
      {required this.postId,
      required this.commentContents,
      required this.commentId});

  int postId;
  int? commentId;
  String commentContents;
}

class PreviewToggled extends CreateCommentEvent {}
