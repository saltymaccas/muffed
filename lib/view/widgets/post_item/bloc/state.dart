part of 'bloc.dart';

enum PostItemStatus { initial, loading, success, failure }

class PostItemState extends Equatable {
  const PostItemState({this.post, this.status = PostItemStatus.initial, this.error});

  final PostItemStatus status;
  final LemmyPost? post;
  final Object? error;

  @override
  List<Object?> get props => [post, error, status];

  PostItemState copyWith({
    LemmyPost? post,
    Object? error,
    PostItemStatus? status,
  }) {
    return PostItemState(
      post: post ?? this.post,
      error: error,
      status: status ?? this.status,
    );
  }
}
