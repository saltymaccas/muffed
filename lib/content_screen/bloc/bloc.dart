import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';

part 'state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc({required this.repo, required this.postId})
      : super(ContentScreenState(status: ContentScreenStatus.initial)) {
    on<InitializeEvent>((event, emit) async {

      emit(ContentScreenState(status: ContentScreenStatus.loading));

      List<LemmyComment> comments =
          await repo.lemmyRepo.getComments(postId, page: 1);

      emit(ContentScreenState(
          status: ContentScreenStatus.success,
          comments: comments,
          pagesLoaded: 1));
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {

        if(!state.reachedEnd){
          print('[ContentScreenBloc] loading page ${state.pagesLoaded + 1}');

          emit(state.copyWith(isLoadingMore: true));

          List<LemmyComment> comments = await repo.lemmyRepo
              .getComments(postId, page: state.pagesLoaded + 1);

          if(comments.isEmpty){
            emit(state.copyWith(reachedEnd: true));

            print('[ContentScreenBloc] end reached');
          }else{
            emit(state.copyWith(
                isLoadingMore: false,
                pagesLoaded: state.pagesLoaded + 1,
                comments: [...state.comments ?? [], ...comments]));

            print('[ContentScreenBloc] loaded page ${state.pagesLoaded}');
          }



        }
      },
      transformer: droppable(),
    );
  }

  final ServerRepo repo;
  final int postId;
}
