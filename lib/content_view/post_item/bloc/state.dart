part of 'bloc.dart';

class PostItemState extends Equatable {
  PostItemState({required this.post, this.error});

  final LemmyPost post;
  final Object? error;

  @override
  List<Object?> get props => [post, error];

  PostItemState copyWith({
    LemmyPost? post,
    Object? error,
  }) {
    return PostItemState(
      post: post ?? this.post,
      error: error,
    );
  }
}
