import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class UserScreenBloc extends Bloc<UserScreenEvent, UserScreenState> {
  ///
  UserScreenBloc({this.userId, this.username, required this.repo})
      : assert(userId != null || username != null,
            'Both username and user id == null'),
        super(UserScreenState(userId: userId, username: username)) {
    on<InitializeEvent>((event, emit) async {
      emit(state.copyWith(status: UserStatus.loading));

      try {
        final response = await repo.lemmyRepo.getPersonDetails(
          username: state.username,
          id: state.userId,
          page: 1,
        );

        emit(
          state.copyWith(
            page: 1,
            comments: response.comments,
            posts: response.posts,
            status: UserStatus.success,
            user: response.person,
          ),
        );
      } catch (err) {
        emit(state.copyWith(errorMessage: err, status: UserStatus.failure));
        rethrow;
      }
    });
  }

  final int? userId;
  final String? username;
  final ServerRepo repo;
}
