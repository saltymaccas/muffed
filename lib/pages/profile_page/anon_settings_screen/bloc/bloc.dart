import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class AnonSettingsBloc extends Bloc<AnonSettingsEvent, AnonSettingsState> {
  ///
  AnonSettingsBloc({required this.repo}) : super(AnonSettingsState()) {
    on<UrlTextFieldChanged>(
      (event, emit) {
        emit(state.copyWith(urlInput: event.text, isLoading: true));
        try {
          repo.lemmyRepo.getSpecificSite(event.text);
        } catch (err) {
          emit(
            state.copyWith(isLoading: false, error: err, siteOfInputted: null),
          );
        }
      },
      transformer: restartable(),
    );
  }

  final ServerRepo repo;
}
