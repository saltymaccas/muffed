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
      final mentions = state.mentions.map((e) {
        if (e.id == event.id) {
          return e.copyWith(read: !e.read);
        }
        return e;
      }).toList();
      emit(state.copyWith(mentions: mentions));

      try {
        final response = await repo.lemmyRepo.markMentionAsRead(
          id: event.id,
          read: !state.mentions
              .firstWhere((element) => element.id == event.id)
              .read,
        );
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            mentions: state.mentions.map((e) {
              if (e.id == event.id) {
                return e.copyWith(read: !e.read);
              }
              return e;
            }).toList(),
          ),
        );
      }
    });
    on<ShowAllToggled>((event, emit) {
      emit(state.copyWith(showAll: !state.showAll));
    });
  }

  final ServerRepo repo;
}
