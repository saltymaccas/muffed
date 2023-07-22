part of 'bloc.dart';

final class LoginPageState extends Equatable {
  final String usernameOrEmail;
  final String totp;
  final String password;
  final String serverAddr;

  LoginPageState(
      {this.totp = '', this.password = '', this.usernameOrEmail = '', this.serverAddr = ''});

  @override
  List<Object?> get props => [usernameOrEmail, password, totp, serverAddr];

  LoginPageState copyWith({
    String? serverAddr,
    String? usernameOrEmail,
    String? totp,
    String? password,
  }) {
    return LoginPageState(
      serverAddr: serverAddr ?? this.serverAddr,
      usernameOrEmail: usernameOrEmail ?? this.usernameOrEmail,
      totp: totp ?? this.totp,
      password: password ?? this.password,
    );
  }
}
