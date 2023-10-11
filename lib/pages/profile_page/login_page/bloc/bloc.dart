import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

/// the bloc that manages the login screen including logging in the user
/// when the user gets logged in it will add the credentials to the
/// [GlobalBloc]
class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  /// initializes the bloc
  LoginPageBloc(this.repo, this.globalBloc) : super(LoginPageState()) {
    on<UserNameOrEmailChanged>((event, emit) {
      emit(state.copyWith(usernameOrEmail: event.value));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.value));
    });
    on<TotpChanged>((event, emit) {
      emit(state.copyWith(totp: event.value));
    });
    on<ServerAddressChanged>((event, emit) {
      emit(state.copyWith(serverAddr: event.value));
    });
    on<RevealPasswordToggled>((event, emit) {
      emit(state.copyWith(revealPassword: !state.revealPassword));
    });

    /// when the user submits the login credentials
    on<Submitted>((event, emit) async {
      final totp = (state.totp == '') ? null : state.totp;

      // if what was entered does not contain "http://" or "https://"
      // it will be added
      final homeServer = (state.serverAddr.contains(r'https?:/\/\'))
          ? state.serverAddr
          : 'https://${state.serverAddr}';

      emit(state.copyWith(loading: true));

      try {
        final result = await repo.lemmyRepo
            .login(state.password, totp, state.usernameOrEmail, homeServer);

        globalBloc.add(
          AccountLoggedIn(
            LemmyAccountData(
              jwt: result.jwt!,
              homeServer: homeServer,
              userName: state.usernameOrEmail,
            ),
          ),
        );

        emit(state.copyWith(loading: false));

        event.onLoginAccepted();
      } catch (err) {
        emit(state.copyWith(errorMessage: err.toString(), loading: false));
      }
    });
  }

  /// the server repo used to log the user in
  final ServerRepo repo;

  /// the global bloc used to add the user credentials when logged in
  final GlobalBloc globalBloc;
}
