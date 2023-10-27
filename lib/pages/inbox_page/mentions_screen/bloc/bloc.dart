import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

/// The bloc for the inbox page
class MentionsBloc extends Bloc<MentionsEvent, MentionsState> {
  /// The bloc for the inbox page
  MentionsBloc({required this.repo}) : super(const MentionsState()) {
    on<Initialize>((event, emit) async {
      emit(state.copyWith(inboxStatus: MentionsStatus.loading));
      try {
        final response = await repo.lemmyRepo.getMention();
        emit(
          state.copyWith(
            inboxStatus: MentionsStatus.success,
            replies: response,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            inboxStatus: MentionsStatus.failure,
            error: err,
          ),
        );
      }
    });
  }

  final ServerRepo repo;
}
