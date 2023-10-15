part of 'bloc.dart';

class CreateCommentState extends Equatable {
  ///
  const CreateCommentState({
    required this.postId,
    this.parentId,
    this.parentCommentContents,
    this.newCommentContents = '',
    this.isLoading = false,
    this.error,
    this.successfullyPosted = false,
    this.isPreviewing = false,
  });

  final int postId;
  final int? parentId;

  final String? parentCommentContents;

  final String newCommentContents;

  final bool isLoading;
  final Object? error;

  final bool isPreviewing;

  /// Used to tell UI that the comment has been successfully posted
  ///
  /// Which would mean the bloc will not be needed anymore and the UI can close
  final bool successfullyPosted;

  @override
  List<Object?> get props => [
        postId,
        parentId,
        parentCommentContents,
        newCommentContents,
        isLoading,
        error,
        successfullyPosted,
        isPreviewing,
      ];

  CreateCommentState copyWith({
    int? postId,
    int? parentId,
    String? parentCommentContents,
    String? newCommentContents,
    bool? isLoading,
    Object? error,
    bool? successfullyPosted,
    bool? isPreviewing,
  }) {
    return CreateCommentState(
      postId: postId ?? this.postId,
      parentId: parentId ?? this.parentId,
      parentCommentContents:
          parentCommentContents ?? this.parentCommentContents,
      newCommentContents: newCommentContents ?? this.newCommentContents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successfullyPosted: successfullyPosted ?? this.successfullyPosted,
      isPreviewing: isPreviewing ?? this.isPreviewing,
    );
  }
}
