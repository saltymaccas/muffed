import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/domain/lemmy/lemmy.dart';
import 'package:muffed/domain/lemmy_keychain/bloc.dart';
import 'package:muffed/utils/error.dart';

part 'state.dart';
part 'event.dart';
part 'bloc.freezed.dart';

class AddKeyBloc extends Bloc<AddKeyEvent, AddKeyState> {
  AddKeyBloc({required this.lem, required this.keychain})
      : super(
          const AddKeyState(
            status: AddKeyStatus.idle,
          ),
        ) {
    on<Submitted>(_onSubmitted, transformer: droppable());
  }

  Future<void> _onSubmitted(Submitted event, Emitter<AddKeyState> emit) async {
    emit(state.copyWith(status: AddKeyStatus.loading));

    try {
      if (event.authenticate) {
        final response = await lem.run(
          Login(
            usernameOrEmail: event.username,
            password: event.password,
            totp2faToken: (event.twoFA != '') ? event.twoFA : null,
          ),
        );

        keychain.add(
          KeyAdded(
            LemmyKey(
              instanceAddress: event.instanceAddress,
              authToken: response.jwt,
            ),
          ),
        );

        emit(state.copyWith(status: AddKeyStatus.confirmed));
      } else {
        final response = await lem.run(
          GetSiteMetadata(
            url: event.instanceAddress,
          ),
        );
        keychain
            .add(KeyAdded(LemmyKey(instanceAddress: event.instanceAddress)));

        emit(state.copyWith(status: AddKeyStatus.confirmed));
      }
    } catch (e, s) {
      emit(
        state.copyWith(
          status: AddKeyStatus.failure,
          errorMessage: objectToErrorMessage(e),
        ),
      );
    }
  }

  final LemmyRepo lem;
  final LemmyKeychainBloc keychain;
}
