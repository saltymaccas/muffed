import 'package:equatable/equatable.dart';

class ImageUploadState extends Equatable {
  const ImageUploadState({
    this.uploadProgress = 0,
    this.path,
    this.deleteToken,
    this.remoteImageName,
    this.host,
    this.id,
    this.error,
  });

  final int? id;
  final double uploadProgress;

  final String? path;
  final String? host;
  final String? remoteImageName;
  final String? deleteToken;

  final Object? error;

  String? get imageUrl =>
      (remoteImageName != null) ? '$host$path$remoteImageName' : null;

  @override
  List<Object?> get props => [
        host,
        uploadProgress,
        path,
        deleteToken,
        id,
        remoteImageName,
        error,
      ];
}
