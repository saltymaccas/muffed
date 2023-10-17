import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/lemmy/models.dart';

part 'event.dart';
part 'state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  ///
  CreatePostBloc() : super(CreatePostState()) {
    on<CreatePostEvent>((event, emit) {});
  }
}
