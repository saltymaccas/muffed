import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/interfaces/lemmy/client/client.dart';

part 'event.dart';
part 'state.dart';

class UserScreenBloc extends Bloc<UserScreenEvent, UserScreenState> {
  UserScreenBloc({required this.lem, int? userId, String? username})
      : super(UserScreenState(userId: userId, username: username)) {
    on<InitializeEvent>((event, emit) async {
      emit(state.copyWith(status: UserStatus.loading));
      try {
        final response = await lem.getPersonDetails(
          username: state.username,
          personId: state.userId,
        );

        emit(
          state.copyWith(
            page: 1,
            comments: response.comments,
            posts: response.posts,
            status: UserStatus.success,
            user: response.personView,
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
            final response = await lem.getPersonDetails(
              personId: state.userId,
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
                  posts: {...state.posts, ...response.posts}.toList(),
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

  final LemmyClient lem;
}
