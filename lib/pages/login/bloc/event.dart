part of 'bloc.dart';

sealed class LoginPageEvent {}

/// When the user presses "Login" on the login page
class Submitted extends LoginPageEvent {
  Submitted({
    required this.username,
    required this.password,
    required this.serverAddress,
    this.totp,
  });

  final String username;
  final String password;
  final HttpUrl serverAddress;
  final String? totp;
}

class RevealPasswordToggled extends LoginPageEvent {}
