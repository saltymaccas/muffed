part of 'bloc.dart';

abstract class CreatePostEvent {}

class Initalize extends CreatePostEvent {}

class PreviewToggled extends CreatePostEvent {}

class PostSubmitted extends CreatePostEvent {
  PostSubmitted({required this.title, this.body, this.url});

  final String title;
  final String? body;
  final String? url;
}

class ImageToUploadSelected extends CreatePostEvent {
  ImageToUploadSelected({required this.filePath});

  final String filePath;
}

class UploadedImageRemoved extends CreatePostEvent {
  UploadedImageRemoved({required this.id});

  final int id;
}
