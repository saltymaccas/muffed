import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';

part 'event.dart';
part 'state.dart';

class InboxItemBloc extends Bloc<InboxItemEvent, InboxItemState> {
  InboxItemBloc() : super(InboxItemState()) {}
}
