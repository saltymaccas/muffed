import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  InboxBloc() : super(const InboxState()) {
    on<ShowUnreadToggled>((event, emit) {
      emit(state.copyWith(showUnreadOnly: !state.showUnreadOnly));
    });
  }
}
