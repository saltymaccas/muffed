part of 'bloc.dart';

enum UserStatus { initial, loading, success, failure }

final class UserScreenState extends Equatable {
  const UserScreenState({
    this.status = UserStatus.initial,
    this.userId,
    this.username,
    this.user,
    this.comments = const [],
    this.posts = const [],
    this.loading = false,
    this.error,
    this.page = 1,
    this.reachedEnd = false,
  });

  final int? userId;
  final String? username;
  final UserStatus status;
  final PersonView? user;

  final List<CommentView> comments;
  final List<PostView> posts;

  final bool loading;

  final Object? error;

  final int page;

  final bool reachedEnd;

  @override
  List<Object?> get props => [
        userId,
        username,
        status,
        user,
        comments,
        posts,
        loading,
        error,
        page,
        reachedEnd,
      ];

  UserScreenState copyWith({
    int? userId,
    String? username,
    UserStatus? status,
    PersonView? user,
    List<CommentView>? comments,
    List<PostView>? posts,
    bool? loading,
    Object? errorMessage,
    int? page,
    bool? reachedEnd,
  }) {
    return UserScreenState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      status: status ?? this.status,
      user: user ?? this.user,
      comments: comments ?? this.comments,
      posts: posts ?? this.posts,
      loading: loading ?? this.loading,
      error: errorMessage,
      page: page ?? this.page,
      reachedEnd: reachedEnd ?? this.reachedEnd,
    );
  }
}
