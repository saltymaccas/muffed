import 'package:equatable/equatable.dart';

class ImageUploadState extends Equatable {
  ImageUploadState({
    this.uploadProgress = 0,
    this.imageLink,
    this.deleteToken,
    this.imageName,
    this.baseUrl,
    this.id,
    this.error,
  });

  final int? id;
  final double uploadProgress;

  final String? imageLink;
  final String? baseUrl;
  final String? imageName;
  final String? deleteToken;

  final Object? error;

  @override
  List<Object?> get props => [
        baseUrl,
        uploadProgress,
        imageLink,
        deleteToken,
        id,
        imageName,
        error,
      ];

  ImageUploadState copyWith({
    int? id,
    double? uploadProgress,
    String? imageLink,
    String? baseUrl,
    String? imageName,
    String? deleteToken,
    Object? error,
  }) {
    return ImageUploadState(
      id: id ?? this.id,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      imageLink: imageLink ?? this.imageLink,
      baseUrl: baseUrl ?? this.baseUrl,
      imageName: imageName ?? this.imageName,
      deleteToken: deleteToken ?? this.deleteToken,
      error: error ?? this.error,
    );
  }
}
