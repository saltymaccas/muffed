import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class AnonSettingsBloc extends Bloc<AnonSettingsEvent, AnonSettingsState> {
  ///
  AnonSettingsBloc({required this.repo, required this.globalBloc})
      : super(AnonSettingsState(
            urlInput: globalBloc.state.lemmyDefaultHomeServer)) {
    on<UrlTextFieldChanged>(
      (event, emit) {
        emit(state.copyWith(urlInput: event.text, setSiteToNull: true));
      },
    );
    on<SaveRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      if (state.urlInput != '') {
        try {
          final response = await repo.lemmyRepo.getSpecificSite(state.urlInput);

          emit(state.copyWith(isLoading: false, siteOfInputted: response));

          globalBloc.add(LemmyDefaultHomeServerChanged(state.urlInput));
        } catch (err) {
          emit(
            state.copyWith(
              isLoading: false,
              error: 'Could not connect to lemmy server',
            ),
          );
        }
      } else {
        emit(state.copyWith(error: 'A home server must be specified'));
      }
    });
  }

  final ServerRepo repo;
  final GlobalBloc globalBloc;
}
