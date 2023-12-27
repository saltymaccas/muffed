part of 'bloc.dart';

class CreateCommentState extends Equatable {
  ///
  CreateCommentState({
    this.isPosting = true,
    this.exception,
    this.successfullyPosted = false,
    this.isPreviewing = false,
    this.commentBeingEdited,
    SplayTreeMap<int, ImageUploadState>? images,
  }) : images = images ?? SplayTreeMap<int, ImageUploadState>();

  final bool isPosting;
  final MException? exception;

  final bool isPreviewing;

  final LemmyComment? commentBeingEdited;

  final SplayTreeMap<int, ImageUploadState> images;

  /// Used to tell UI that the comment has been successfully posted
  ///
  /// Which would mean the bloc will not be needed anymore and the UI can close
  final bool successfullyPosted;

  @override
  List<Object?> get props => [
        isPosting,
        exception,
        successfullyPosted,
        isPreviewing,
        images,
        commentBeingEdited,
      ];

  CreateCommentState copyWith({
    bool? isLoading,
    MException? exception,
    bool? successfullyPosted,
    bool? isPreviewing,
    SplayTreeMap<int, ImageUploadState>? images,
    LemmyComment? commentBeingEdited,
  }) {
    return CreateCommentState(
      isPosting: isLoading ?? isPosting,
      exception: exception,
      successfullyPosted: successfullyPosted ?? this.successfullyPosted,
      isPreviewing: isPreviewing ?? this.isPreviewing,
      images: images ?? this.images,
      commentBeingEdited: commentBeingEdited ?? this.commentBeingEdited,
    );
  }
}
