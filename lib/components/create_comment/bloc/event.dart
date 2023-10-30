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

class ImageToUploadSelected extends CreateCommentEvent {
  ImageToUploadSelected({required this.filePath});

  final String filePath;
}

class UploadedImageRemoved extends CreateCommentEvent {
  UploadedImageRemoved({required this.id});

  final int id;
}
