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
  });

  final int postId;
  final int? parentId;

  final String? parentCommentContents;

  final String newCommentContents;

  final bool isLoading;
  final Object? error;

  @override
  List<Object?> get props => [
        postId,
        parentId,
        parentCommentContents,
        newCommentContents,
        isLoading,
        error,
      ];

  CreateCommentState copyWith({
    int? postId,
    int? parentId,
    String? parentCommentContents,
    String? newCommentContents,
    bool? isLoading,
    Object? error,
  }) {
    return CreateCommentState(
      postId: postId ?? this.postId,
      parentId: parentId ?? this.parentId,
      parentCommentContents:
          parentCommentContents ?? this.parentCommentContents,
      newCommentContents: newCommentContents ?? this.newCommentContents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
