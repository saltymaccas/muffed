part of 'bloc.dart';

enum PostStatus { loading, failure, idle }

@freezed
class PostState with _$PostState {
  const factory PostState({
    required PostStatus status,
    String? errorMessage,
    PostView? post,
  }) = _PostState;
}
