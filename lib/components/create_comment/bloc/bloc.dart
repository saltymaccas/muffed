import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CreateCommentBloc');

class CreateCommentBloc extends Bloc<CreateCommentEvent, CreateCommentState> {
  ///
  CreateCommentBloc({
    required this.initialState,
    required this.repo,
    required this.onSuccess,
  }) : super(initialState) {
    on<Submitted>((event, emit) async {
      _log.info('Comment submitted');
      if (state.newCommentContents.isNotEmpty) {
        emit(state.copyWith(isLoading: true));

        try {
          final response = await repo.lemmyRepo.createComment(
            state.newCommentContents,
            state.postId,
            state.parentId,
          );

          emit(state.copyWith(isLoading: false, successfullyPosted: true));
        } catch (err) {
          emit(state.copyWith(isLoading: false, error: err));
        }
      } else {
        _log.info('Comment submitted with no text');
        emit(state.copyWith(error: 'No text inputted'));
      }
    });
    on<NewCommentTextboxChanged>((event, emit) {
      emit(state.copyWith(newCommentContents: event.text));
    });
  }

  final CreateCommentState initialState;
  final ServerRepo repo;
  final void Function() onSuccess;
}
