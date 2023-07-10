part of 'bloc.dart';

enum ContentScreenStatus { initial, loading, success, failure }

class ContentScreenState extends Equatable{
  final ContentScreenStatus status;
  final List<LemmyComment>? comments;
  final int pagesLoaded;
  final bool isLoadingMore;


  ContentScreenState({required this.status, this.comments, this.pagesLoaded = 0, this.isLoadingMore = false});


  @override
  List<Object?> get props => [status, comments, pagesLoaded, isLoadingMore];

  ContentScreenState copyWith({
    bool? isLoadingMore,
    ContentScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
  }) {
    return ContentScreenState(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
    );
  }
}