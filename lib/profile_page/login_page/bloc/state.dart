part of 'bloc.dart';

final class LoginPageState extends Equatable {
  final String usernameOrEmail;
  final String totp;
  final String password;
  final String serverAddr;
  final String? errorMessage;

  LoginPageState(
      {this.totp = '',
      this.password = '',
      this.usernameOrEmail = '',
      this.serverAddr = '',
      this.errorMessage});

  @override
  List<Object?> get props =>
      [usernameOrEmail, password, totp, serverAddr, errorMessage];

  LoginPageState copyWith({
    String? errorMessage,
    String? serverAddr,
    String? usernameOrEmail,
    String? totp,
    String? password,
  }) {
    return LoginPageState(
      errorMessage: errorMessage,
      serverAddr: serverAddr ?? this.serverAddr,
      usernameOrEmail: usernameOrEmail ?? this.usernameOrEmail,
      totp: totp ?? this.totp,
      password: password ?? this.password,
    );
  }
}
