import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

/// The bloc for the inbox page
class RepliesBloc extends Bloc<RepliesEvent, RepliesState> {
  /// The bloc for the inbox page
  RepliesBloc({required this.repo}) : super(const RepliesState()) {
    on<Initialize>((event, emit) async {
      emit(state.copyWith(inboxStatus: RepliesStatus.loading));
      try {
        final response =
            await repo.lemmyRepo.getReplies(unreadOnly: state.showAll, page: 1);
        emit(
          state.copyWith(
            inboxStatus: RepliesStatus.success,
            replies: response,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            inboxStatus: RepliesStatus.failure,
            error: err,
          ),
        );
      }
    });
    on<MarkAsReadToggled>((event, emit) async {
      final ogRepliesList = [...state.replies];

      final replies = [...state.replies];

      final toggledTo = !replies[event.index].read;

      replies[event.index] = replies[event.index].copyWith(read: toggledTo);

      emit(state.copyWith(replies: replies));

      try {
        final response = await repo.lemmyRepo.markReplyAsRead(
          id: event.id,
          read: toggledTo,
        );
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            replies: ogRepliesList,
          ),
        );
      }
    }, transformer: restartable());
    on<ShowAllToggled>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, showAll: !state.showAll));
        try {
          final response = await repo.lemmyRepo
              .getReplies(page: 1, unreadOnly: !state.showAll);
          emit(
            state.copyWith(
              isLoading: false,
              replies: response,
            ),
          );
        } catch (err) {
          emit(state.copyWith(error: err, showAll: state.showAll));
        }
      },
      transformer: restartable(),
    );
    on<Refresh>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));
      try {
        final response = await repo.lemmyRepo
            .getReplies(page: 1, unreadOnly: !state.showAll);

        emit(
          state.copyWith(
            isRefreshing: false,
            replies: response,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(state.copyWith(error: err, isRefreshing: false));
      }
    });
    on<ReachedEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd) {
          emit(state.copyWith(isLoading: true));
          try {
            final response = await repo.lemmyRepo.getReplies(
              page: state.pagesLoaded + 1,
              unreadOnly: !state.showAll,
            );
            if (response.isEmpty) {
              emit(state.copyWith(reachedEnd: true, isLoading: false));
            } else {
              emit(
                state.copyWith(
                  isLoading: false,
                  replies: [...state.replies, ...response],
                  pagesLoaded: state.pagesLoaded + 1,
                ),
              );
            }
          } catch (err) {
            emit(state.copyWith(error: err, isLoading: false));
          }
        }
      },
      transformer: droppable(),
    );
  }

  final ServerRepo repo;
}
