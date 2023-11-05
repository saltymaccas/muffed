part of 'bloc.dart';

class CreateCommentState extends Equatable {
  ///
  CreateCommentState({
    this.isLoading = false,
    this.error,
    this.successfullyPosted = false,
    this.isPreviewing = false,
    this.commentBeingEdited,
    SplayTreeMap<int, ImageUploadState>? images,
  }) : images = images ?? SplayTreeMap<int, ImageUploadState>();

  final bool isLoading;
  final Object? error;

  final bool isPreviewing;

  final LemmyComment? commentBeingEdited;

  final SplayTreeMap<int, ImageUploadState> images;

  /// Used to tell UI that the comment has been successfully posted
  ///
  /// Which would mean the bloc will not be needed anymore and the UI can close
  final bool successfullyPosted;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        successfullyPosted,
        isPreviewing,
        images,
        commentBeingEdited,
      ];

  CreateCommentState copyWith({
    bool? isLoading,
    Object? error,
    bool? successfullyPosted,
    bool? isPreviewing,
    SplayTreeMap<int, ImageUploadState>? images,
    LemmyComment? commentBeingEdited,
  }) {
    return CreateCommentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successfullyPosted: successfullyPosted ?? this.successfullyPosted,
      isPreviewing: isPreviewing ?? this.isPreviewing,
      images: images ?? this.images,
      commentBeingEdited: commentBeingEdited ?? this.commentBeingEdited,
    );
  }
}
