part of 'bloc.dart';

enum ContentScreenStatus { initial, loading, success, failure }

class ContentScreenState extends Equatable {
  final ContentScreenStatus status;
  final List<LemmyComment>? comments;
  final int pagesLoaded;
  final bool isLoadingMore;
  final bool reachedEnd;
  final bool createdCommentGettingPosted;
  final String? errorMessage;
  final String? createCommentErrorMessage;

  ContentScreenState({
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

  ContentScreenState copyWith({
    String? createCommentErrorMessage,
    String? errorMessage,
    bool? reachedEnd,
    bool? isLoadingMore,
    ContentScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
    bool? createdCommentGettingPosted,
  }) {
    return ContentScreenState(
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
