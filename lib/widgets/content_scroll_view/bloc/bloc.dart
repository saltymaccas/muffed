import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('ContentScrollView');

/// Controls the state of a content scroll view
class ContentScrollBloc extends Bloc<ContentScrollEvent, ContentScrollState> {
  ///
  ContentScrollBloc({required ContentRetriever contentRetriever})
      : super(
          ContentScrollState(
            status: ContentScrollStatus.initial,
            retrieveContent: contentRetriever,
          ),
        ) {
    on<Initialise>((event, emit) async {
      emit(
        state.copyWith(
          status: ContentScrollStatus.loading,
        ),
      );

      _log.info('Loading initial posts');

      try {
        final response = await state.retrieveContent(page: 1);
        emit(
          state.copyWith(
            content: response,
            status: ContentScrollStatus.success,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        _log.shout('Loading initial posts failed', err);
        emit(
          state.copyWith(
            status: ContentScrollStatus.failure,
            error: err,
          ),
        );
      }
    });
    on<PullDownRefresh>((event, emit) async {
      try {
        emit(state.copyWith(isRefreshing: true));

        final response = await state.retrieveContent(page: 1);

        emit(
          state.copyWith(
            content: response,
            isRefreshing: false,
            pagesLoaded: 1,
          ),
        );
      } catch (err) {
        emit(state.copyWith(isRefreshing: false, error: err));
      }
    });
    on<ReachedNearEndOfScroll>(
      (event, emit) async {
        try {
          if (!state.reachedEnd && !state.isLoadingMore) {
            _log.info('Loading page ${state.pagesLoaded + 1}');
            emit(state.copyWith(isLoadingMore: true));

            final response =
                await state.retrieveContent(page: state.pagesLoaded + 1);

            final newContentList = {...state.content!, ...response}.toList();

            if (newContentList.length == state.content!.length) {
              emit(state.copyWith(isLoadingMore: false, reachedEnd: true));
            } else {
              emit(
                state.copyWith(
                  content: newContentList,
                  pagesLoaded: state.pagesLoaded + 1,
                  isLoadingMore: false,
                ),
              );
            }

            _log.info('Loaded page ${state.pagesLoaded}');
          }
        } catch (err) {
          emit(state.copyWith(error: err, isLoadingMore: false));
        }
      },
      transformer: droppable(),
    );
    on<RetrieveContentMethodChanged>(
      (event, emit) async {
        try {
          emit(
            state.copyWith(
              retrieveContent: event.retrieveContent,
              isLoading: true,
            ),
          );

          final response = await event.retrieveContent(page: 1);

          emit(
            state.copyWith(
              loadedRetrieveContent: event.retrieveContent,
              content: response,
              pagesLoaded: 1,
              isLoading: false,
            ),
          );
        } catch (err) {
          emit(
            state.copyWith(
              retrieveContent: state.loadedRetrieveContent,
              error: err,
              isLoading: false,
            ),
          );
        }
      },
      transformer: droppable(),
    );
  }

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
