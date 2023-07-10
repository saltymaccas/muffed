part of 'bloc.dart';

enum ContentScreenStatus { initial, loading, success, failure }

class ContentScreenState extends Equatable{
  final ContentScreenStatus status;
  final List<LemmyComment>? comments;
  final int pagesLoaded;


  ContentScreenState({required this.status, this.comments, this.pagesLoaded = 0});


  @override
  List<Object?> get props => [status, comments, pagesLoaded];

  ContentScreenState copyWith({
    ContentScreenStatus? status,
    List<LemmyComment>? comments,
    int? pagesLoaded,
  }) {
    return ContentScreenState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      pagesLoaded: pagesLoaded ?? this.pagesLoaded,
    );
  }
}