part of 'bloc.dart';

enum CommentScreenStatus { initial, loading, success, failure }

class CommentScreenState extends Equatable {

  ///
  const CommentScreenState({
    required this.status,
    this.createdCommentGettingPosted = false,
    this.comments,
    this.pagesLoaded = 0,
    this.isLoadingMore = false,
    this.reachedEnd = false,
    this.errorMessage,
    this.createCommentErrorMessage,
    this.isRefreshing = false,
  });

  final CommentScreenStatus status;
  final List<LemmyComment>? comments;
  final int pagesLoaded;
  final bool isLoadingMore;

  /// whether all the comment pages have been loaded, so there are no more
  /// comment to be loaded
  final bool reachedEnd;

  final bool createdCommentGettingPosted;

  /// The error message that appears instead of the comments if the comment
  /// screen state is failure. If the comment screen state is loaded it will
  /// appear as a snack bar.
  final String? errorMessage;

  /// the error message that will appear on the add comment dialog is an error
  /// occurs with adding the comment
  final String? createCommentErrorMessage;
  final bool isRefreshing;

  @override
  List<Object?> get props =>
      [
        status,
        comments,
        pagesLoaded,
        isLoadingMore,
        reachedEnd,
        errorMessage,
        createdCommentGettingPosted,
        createCommentErrorMessage,
        isRefreshing,
      ];

  CommentScreenState copyWith({
    bool? isRefreshing,
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
      isRefreshing: isRefreshing ?? this.isRefreshing,
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
