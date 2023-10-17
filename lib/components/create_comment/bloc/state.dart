part of 'bloc.dart';

class CreateCommentState extends Equatable {
  ///
  const CreateCommentState({
    this.isLoading = false,
    this.error,
    this.successfullyPosted = false,
    this.isPreviewing = false,
  });

  final bool isLoading;
  final Object? error;

  final bool isPreviewing;

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
      ];

  CreateCommentState copyWith({
    bool? isLoading,
    Object? error,
    bool? successfullyPosted,
    bool? isPreviewing,
  }) {
    return CreateCommentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successfullyPosted: successfullyPosted ?? this.successfullyPosted,
      isPreviewing: isPreviewing ?? this.isPreviewing,
    );
  }
}
