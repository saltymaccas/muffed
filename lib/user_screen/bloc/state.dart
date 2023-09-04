part of 'bloc.dart';

enum UserStatus { initial, loading, success, failure }

final class UserScreenState extends Equatable {
  UserScreenState({
    this.status = UserStatus.initial,
    this.userId,
    this.username,
    this.user,
    this.comments = const [],
    this.posts = const [],
    this.loading = false,
    this.errorMessage,
    this.page = 1,
  }) : assert(userId != null || userId != null,
            'Both userId and username equals null');

  final int? userId;
  final String? username;
  final UserStatus status;
  final LemmyPerson? user;

  final List<LemmyComment> comments;
  final List<LemmyPost> posts;

  final bool loading;

  final Object? errorMessage;

  final int page;

  @override
  List<Object?> get props => [
        userId,
        username,
        status,
        user,
        comments,
        posts,
        loading,
        errorMessage,
        page,
      ];

  UserScreenState copyWith(
      {int? userId,
      String? username,
      UserStatus? status,
      LemmyPerson? user,
      List<LemmyComment>? comments,
      List<LemmyPost>? posts,
      bool? loading,
      Object? errorMessage,
      int? page}) {
    return UserScreenState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      status: status ?? this.status,
      user: user ?? this.user,
      comments: comments ?? this.comments,
      posts: posts ?? this.posts,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      page: page ?? this.page,
    );
  }
}
