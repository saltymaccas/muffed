import 'package:equatable/equatable.dart';

class ImageUploadState extends Equatable {
  ImageUploadState({
    this.uploadProgress = 0,
    this.imageLink,
    this.deleteToken,
    this.imageName,
    this.baseUrl,
    this.id,
  });

  final int? id;
  final double uploadProgress;

  final String? imageLink;
  final String? baseUrl;
  final String? imageName;
  final String? deleteToken;

  @override
  List<Object?> get props => [
        baseUrl,
        uploadProgress,
        imageLink,
        deleteToken,
        id,
        imageName,
      ];
}
