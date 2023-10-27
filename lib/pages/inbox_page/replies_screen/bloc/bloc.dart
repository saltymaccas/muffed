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
        final response = await repo.lemmyRepo.getReplies();
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
  }

  final ServerRepo repo;
}
