import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

/// The bloc for the inbox page
class InboxBloc extends Bloc<InboxEvent, InboxState> {
  /// The bloc for the inbox page
  InboxBloc({required this.repo}) : super(const InboxState()) {
    on<Initialize>((event, emit) async {
      emit(state.copyWith(inboxStatus: InboxStatus.loading));
      try {
        final response = await repo.lemmyRepo.getRepliesAndMentions();
        emit(
          state.copyWith(
            inboxStatus: InboxStatus.success,
            replies: response,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            inboxStatus: InboxStatus.failure,
            error: err,
          ),
        );
      }
    });
  }

  final ServerRepo repo;
}
