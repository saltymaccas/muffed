import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('InboxItemBloc');

abstract class InboxItemBloc extends Bloc<InboxItemEvent, InboxItemState> {
  InboxItemBloc({required bool read, required this.repo})
      : super(InboxItemState(read: read)) {
    on<ReadStatusToggled>(onReadStatusToggled);
  }

  Future<void> onReadStatusToggled(
    ReadStatusToggled event,
    Emitter<InboxItemState> emit,
  );

  final ServerRepo repo;
}

class ReplyItemBloc extends InboxItemBloc {
  ReplyItemBloc({required super.read, required super.repo});

  @override
  Future<void> onReadStatusToggled(
    ReadStatusToggled event,
    Emitter<InboxItemState> emit,
  ) async {
    emit(super.state.copyWith(read: !super.state.read));
    try {
      final response = await super
          .repo
          .lemmyRepo
          .markReplyAsRead(id: event.id, read: super.state.read);
    } catch (exc, stackTrace) {
      final exception = MException(exc, stackTrace)..log(_log);
      emit(state.copyWith(read: !super.state.read, exception: exception));
    }
  }
}

class MentionItemBloc extends InboxItemBloc {
  MentionItemBloc({required super.read, required super.repo});

  @override
  Future<void> onReadStatusToggled(
    ReadStatusToggled event,
    Emitter<InboxItemState> emit,
  ) async {
    emit(super.state.copyWith(read: !super.state.read));
    try {
      final response = await super
          .repo
          .lemmyRepo
          .markMentionAsRead(id: event.id, read: super.state.read);
    } catch (exc, stackTrace) {
      final exception = MException(exc, stackTrace)..log(_log);
      emit(state.copyWith(read: !super.state.read, exception: exception));
    }
  }
}
