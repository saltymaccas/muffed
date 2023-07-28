part of 'bloc.dart';

enum CommentScreenStatus { initial, loading, success, failure }

class CommentScreenState extends Equatable {
  final CommentScreenStatus status;
  final List<LemmyComment>? comments;
  final int pagesLoaded;
  final bool isLoadingMore;
  final bool reachedEnd;
  final bool createdCommentGettingPosted;
  final String? errorMessage;
  final String? createCommentErrorMessage;

  CommentScreenState({
    required this.status,
    this.createdCommentGettingPosted = false,
    this.comments,
    this.pagesLoaded = 0,
    this.isLoadingMore = false,
    this.reachedEnd = false,
    this.errorMessage,
    this.createCommentErrorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        comments,
        pagesLoaded,
        isLoadingMore,
        reachedEnd,
        errorMessage,
        createdCommentGettingPosted,
        createCommentErrorMessage,
      ];

  CommentScreenState copyWith({
    String? createCommentErrorMessage,
    String? errorMessage,
    bool? reachedEnd,
    bool? isLoadingMore,
    CommentScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
    bool? createdCommentGettingPosted,
  }) {
    return CommentScreenState(
      createdCommentGettingPosted:
          createdCommentGettingPosted ?? this.createdCommentGettingPosted,
      errorMessage: errorMessage,
      createCommentErrorMessage: createCommentErrorMessage,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
    );
  }
}
