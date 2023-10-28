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
        final response =
            await repo.lemmyRepo.getMention(unreadOnly: state.showAll, page: 1);
        emit(
          state.copyWith(
            inboxStatus: MentionsStatus.success,
            mentions: response,
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
    on<MarkAsReadToggled>((event, emit) async {
      final ogMentionsList = [...state.mentions];

      final mentions = [...state.mentions];

      final toggledTo = !mentions[event.index].read;

      mentions[event.index] = mentions[event.index].copyWith(read: toggledTo);

      emit(state.copyWith(mentions: mentions));

      try {
        final response = await repo.lemmyRepo.markMentionAsRead(
          id: event.id,
          read: toggledTo,
        );
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            mentions: ogMentionsList,
          ),
        );
      }
    });
    on<ShowAllToggled>((event, emit) async {
      emit(state.copyWith(isLoading: true, showAll: !state.showAll));
      try {
        final response = await repo.lemmyRepo
            .getMention(page: 1, unreadOnly: !state.showAll);
        emit(
          state.copyWith(
            isLoading: false,
            mentions: response,
          ),
        );
      } catch (err) {
        emit(state.copyWith(error: err, showAll: state.showAll));
      }
    });
  }

  final ServerRepo repo;
}
