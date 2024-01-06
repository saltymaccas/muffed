import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/models/models.dart';
import 'package:muffed/db/db.dart';
import 'package:muffed/interfaces/lemmy/client/client.dart';
import 'package:muffed/models/url.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('LoginPageBloc');

/// the bloc that manages the login screen including logging in the user
/// when the user gets logged in it will add the credentials to the
/// [DB]
class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc(this.lem, this.globalBloc) : super(const LoginPageState()) {
    on<RevealPasswordToggled>((event, emit) {
      emit(state.copyWith(revealPassword: !state.revealPassword));
    });

    /// when the user submits the login credentials
    on<Submitted>((event, emit) async {
      final totp = (event.totp == '') ? null : event.totp;

      emit(state.copyWith(loading: true));

      try {
        final login = await lem.login(
          usernameOrEmail: event.username,
          password: event.password,
          totp2faToken: totp,
        );

  // FIXME:
        // globalBloc.add(
        //   AccountLoggedIn(
        //     LemmyAccountData(
        //       jwt: login.jwt!,
        //       homeServer: event.serverAddress,
        //       name: getPerson.name,
        //       id: getPerson.id,
        //     ),
        //   ),
        // );

        final getPerson = await lem.getSite(

        );


        emit(state.copyWith(loading: false));

        emit(state.copyWith(successfullyLoggedIn: true));
      } catch (exc, stacktrace) {
        final exception = MException(exc, stacktrace)..log(_log);
        emit(state.copyWith(exception: exception, loading: false));
      }
    });
  }

  /// the server repo used to log the user in
  final LemmyClient lem;

  /// the global bloc used to add the user credentials when logged in
  final DB globalBloc;
}
