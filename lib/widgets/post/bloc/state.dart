part of 'bloc.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  const PostState({this.post, this.status = PostStatus.initial, this.exception})
      : assert(
          status != PostStatus.success || post != null,
          'Post cannot be null when status is success',
        );

  final PostStatus status;
  final PostView? post;
  final Object? exception;

  @override
  List<Object?> get props => [post, exception, status];

  PostState copyWith({
    PostView? post,
    Object? exception,
    PostStatus? status,
  }) {
    return PostState(
      post: post ?? this.post,
      exception: exception,
      status: status ?? this.status,
    );
  }
}
