import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';

part 'state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc({required this.repo, required this.postId})
      : super(ContentScreenState(status: ContentScreenStatus.initial)) {
    on<InitializeEvent>((event, emit) async {
      List<LemmyComment> comments = await repo.lemmyRepo.getComments(postId, page: 1);

      emit(ContentScreenState(
          status: ContentScreenStatus.success, comments: comments));
    });
  }

  final ServerRepo repo;
  final int postId;
}
