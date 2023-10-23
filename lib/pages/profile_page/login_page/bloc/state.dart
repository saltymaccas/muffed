part of 'bloc.dart';

final class LoginPageState extends Equatable {
  final String usernameOrEmail;
  final String totp;
  final String password;
  final String serverAddr;
  final Object? errorMessage;
  final bool loading;
  final bool revealPassword;

  LoginPageState({
    this.totp = '',
    this.password = '',
    this.usernameOrEmail = '',
    this.serverAddr = '',
    this.errorMessage,
    this.loading = false,
    this.revealPassword = false,
  });

  @override
  List<Object?> get props => [
        usernameOrEmail,
        password,
        totp,
        serverAddr,
        errorMessage,
        loading,
        revealPassword,
      ];

  LoginPageState copyWith({
    bool? loading,
    Object? errorMessage,
    String? serverAddr,
    String? usernameOrEmail,
    String? totp,
    String? password,
    bool? revealPassword,
  }) {
    return LoginPageState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      serverAddr: serverAddr ?? this.serverAddr,
      usernameOrEmail: usernameOrEmail ?? this.usernameOrEmail,
      totp: totp ?? this.totp,
      password: password ?? this.password,
      revealPassword: revealPassword ?? this.revealPassword,
    );
  }
}
