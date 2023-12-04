part of 'bloc.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  const PostState({this.post, this.status = PostStatus.initial, this.error})
      : assert(
          status != PostStatus.success || post != null,
          'Post cannot be null when status is success',
        );

  final PostStatus status;
  final LemmyPost? post;
  final Object? error;

  @override
  List<Object?> get props => [post, error, status];

  PostState copyWith({
    LemmyPost? post,
    Object? error,
    PostStatus? status,
  }) {
    return PostState(
      post: post ?? this.post,
      error: error,
      status: status ?? this.status,
    );
  }
}
