part of 'bloc.dart';

final class LoginPageState extends Equatable {
  const LoginPageState({
    this.exception,
    this.loading = false,
    this.revealPassword = false,
    this.successfullyLoggedIn = false,
  });

  final MException? exception;
  final bool loading;
  final bool revealPassword;
  final bool successfullyLoggedIn;

  @override
  List<Object?> get props => [
        exception,
        loading,
        revealPassword,
        successfullyLoggedIn,
      ];

  LoginPageState copyWith({
    bool? loading,
    MException? exception,
    bool? revealPassword,
    bool? successfullyLoggedIn,
  }) {
    return LoginPageState(
      loading: loading ?? this.loading,
      exception: exception,
      revealPassword: revealPassword ?? this.revealPassword,
      successfullyLoggedIn: successfullyLoggedIn ?? this.successfullyLoggedIn,
    );
  }
}
