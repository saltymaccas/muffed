import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('HomePageBloc');

/// The bloc that controls the home page
class ContentScrollBloc extends Bloc<ContentScrollEvent, ContentScrollState> {
  ///
  ContentScrollBloc({required this.retrieveContent})
      : super(const ContentScrollState(status: ContentScrollStatus.initial)) {
    on<Initialise>((event, emit) async {
      emit(
        const ContentScrollState(
          status: ContentScrollStatus.loading,
        ),
      );

      _log.info('Loading initial posts');

      try {
        final response = await retrieveContent(page: 1);
        emit(
          ContentScrollState(
            status: ContentScrollStatus.success,
            content: response,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        _log.shout('Loading initial posts failed', err);
        emit(
          ContentScrollState(
            status: ContentScrollStatus.failure,
            error: err,
          ),
        );
      }
    });
    on<PullDownRefresh>((event, emit) async {
      try {
        emit(state.copyWith(isRefreshing: true));

        final response = await retrieveContent(page: 1);

        emit(
          state.copyWith(
            content: response,
            isRefreshing: false,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(state.copyWith(isRefreshing: false, errorMessage: err));
      }
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        try {
          if (!state.reachedEnd && !state.isLoadingMore) {
            _log.info('Loading page ${state.pagesLoaded + 1}');
            emit(state.copyWith(isLoading: true));

            final response = await retrieveContent(page: state.pagesLoaded + 1);

            if (response.isEmpty) {
              emit(state.copyWith(isLoading: false, reachedEnd: true));
            } else {
              emit(
                state.copyWith(
                  content: {...state.content!, ...response}.toList(),
                  pagesLoaded: state.pagesLoaded + 1,
                  isLoading: false,
                ),
              );
            }

            _log.info('Loaded page ${state.pagesLoaded}');
          }
        } catch (err) {
          emit(state.copyWith(errorMessage: err, isLoading: false));
        }
      },
      transformer: droppable(),
    );
  }

  final RetrieveContent retrieveContent;

  @override
  void onChange(Change<ContentScrollState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(
    Transition<ContentScrollEvent, ContentScrollState> transition,
  ) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}
