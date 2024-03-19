import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/server_repo.dart';

part 'event.dart';
part 'state.dart';

class UserScreenBloc extends Bloc<UserScreenEvent, UserScreenState> {
  UserScreenBloc({required this.repo, this.userId, this.username})
      : super(UserScreenState(userId: userId, username: username)) {
    on<InitializeEvent>((event, emit) async {
      emit(state.copyWith(status: UserStatus.loading));

      try {
        final response = await repo.lemmyRepo.getPersonDetails(
          username: state.username,
          id: state.userId,
        );

        emit(
          state.copyWith(
            page: 1,
            comments: response.comments,
            posts: [],
            status: UserStatus.success,
            user: response.person,
          ),
        );
      } catch (err) {
        emit(state.copyWith(errorMessage: err, status: UserStatus.failure));
        rethrow;
      }
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd) {
          emit(state.copyWith(loading: true));

          try {
            final response = await repo.lemmyRepo.getPersonDetails(
              id: state.userId,
              username: state.username,
              page: state.page + 1,
            );

            if (response.posts.isEmpty && response.comments.isEmpty) {
              emit(
                state.copyWith(
                  reachedEnd: true,
                  loading: false,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  loading: false,
                  page: state.page + 1,
                  comments: {...state.comments, ...response.comments}.toList(),
                ),
              );
            }
          } catch (err) {
            emit(state.copyWith(loading: false, errorMessage: err));
            rethrow;
          }
        }
      },
      transformer: droppable(),
    );
  }

  final int? userId;
  final String? username;
  final ServerRepo repo;
}
