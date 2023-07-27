part of 'bloc.dart';

enum ContentScreenStatus { initial, loading, success, failure }

class ContentScreenState extends Equatable {
  final ContentScreenStatus status;
  final List<LemmyComment>? comments;
  final int pagesLoaded;
  final bool isLoadingMore;
  final bool reachedEnd;
  final String? errorMessage;

  ContentScreenState({
    required this.status,
    this.comments,
    this.pagesLoaded = 0,
    this.isLoadingMore = false,
    this.reachedEnd = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        comments,
        pagesLoaded,
        isLoadingMore,
        reachedEnd,
        errorMessage,
      ];

  ContentScreenState copyWith({
    String? errorMessage,
    bool? reachedEnd,
    bool? isLoadingMore,
    ContentScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
  }) {
    return ContentScreenState(
      errorMessage: errorMessage,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
    );
  }
}
