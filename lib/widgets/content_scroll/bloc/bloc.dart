import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('ContentScrollView');

/// Controls the state of a content scroll view
class ContentScrollBloc<Data>
    extends Bloc<ContentScrollEvent, ContentScrollState<Data>> {
  ///
  ContentScrollBloc({
    required ContentRetrieverDelegate<Data> contentRetriever,
  }) : super(
          ContentScrollState(
            status: ContentScrollStatus.empty,
            contentDelegate: contentRetriever,
          ),
        ) {
    on<LoadInitialItems>((event, emit) async {
      emit(
        state.copyWith(
          status: ContentScrollStatus.loading,
        ),
      );

      _log.info('Loading initial posts');

      try {
        final response = await state.contentDelegate.retrieveContent(page: 1);
        emit(
          state.copyWith(
            content: response,
            status: ContentScrollStatus.success,
            pagesLoaded: 1,
          ),
        );
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(
          state.copyWith(
            status: ContentScrollStatus.failure,
            exception: exception,
          ),
        );
      }
    });
    on<PullDownRefresh>((event, emit) async {
      try {
        emit(state.copyWith(isRefreshing: true));

        final response = await state.contentDelegate.retrieveContent(page: 1);

        emit(
          state.copyWith(
            content: response,
            isRefreshing: false,
            pagesLoaded: 1,
          ),
        );
      } catch (exc, stackTrace) {
        final exception = MException(exc, stackTrace)..log(_log);
        emit(state.copyWith(isRefreshing: false, exception: exception));
      }
    });
    on<NearScrollEnd>(
      (event, emit) async {
        if (!state.reachedEnd && !state.isLoadingMore) {
          try {
            _log.info('Loading page ${state.pagesLoaded + 1}');
            emit(state.copyWith(isLoadingMore: true));

            final response = await state.contentDelegate
                .retrieveContent(page: state.pagesLoaded + 1);

            if (state.loadedContentDelegate.hasReachedEnd(
              oldContent: state.content,
              newContent: response,
            )) {
              emit(state.copyWith(isLoadingMore: false, reachedEnd: true));
            } else {
              final newContentList = {...state.content, ...response}.toList();
              emit(
                state.copyWith(
                  content: newContentList,
                  pagesLoaded: state.pagesLoaded + 1,
                  isLoadingMore: false,
                ),
              );
            }

            _log.info('Loaded page ${state.pagesLoaded}');
          } catch (exc, stackTrace) {
            final exception = MException(exc, stackTrace)..log(_log);

            emit(state.copyWith(exception: exception, isLoadingMore: false));
          }
        }
      },
      transformer: droppable(),
    );
    on<RetrieveContentDelegateChanged<Data>>(
      (event, emit) async {
        if (event.persistContent) {
          try {
            emit(
              state.copyWith(
                contentDelegate: event.newRetrieveContentDelegate,
                isLoading: true,
              ),
            );

            final response =
                await event.newRetrieveContentDelegate.retrieveContent(page: 1);

            emit(
              state.copyWith(
                loadedContentDelegate: event.newRetrieveContentDelegate,
                content: response,
                pagesLoaded: 1,
                isLoading: false,
              ),
            );
          } catch (exc, stackTrace) {
            final exception = MException(exc, stackTrace)..log(_log);
            emit(
              state.copyWith(
                contentDelegate: state.loadedContentDelegate,
                exception: exception,
                isLoading: false,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              status: ContentScrollStatus.loading,
              contentDelegate: event.newRetrieveContentDelegate,
              pagesLoaded: 0,
              content: [],
            ),
          );
          try {
            final response =
                await event.newRetrieveContentDelegate.retrieveContent(page: 1);
            emit(
              state.copyWith(
                loadedContentDelegate: event.newRetrieveContentDelegate,
                content: response,
                pagesLoaded: 1,
                status: ContentScrollStatus.success,
              ),
            );
          } catch (exc, stackTrace) {
            final exception = MException(exc, stackTrace)..log(_log);
            emit(
              state.copyWith(
                exception: exception,
                status: ContentScrollStatus.failure,
              ),
            );
          }
        }
      },
      transformer: droppable(),
    );
  }

  @override
  void onChange(Change<ContentScrollState<Data>> change) {
    super.onChange(change);
    _log.finest(change);
  }

  @override
  void onTransition(
    Transition<ContentScrollEvent, ContentScrollState<Data>> transition,
  ) {
    super.onTransition(transition);
    _log.finest(transition);
  }
}
