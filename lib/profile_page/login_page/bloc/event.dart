part of 'bloc.dart';

sealed class LoginPageEvent {}

class UserNameOrEmailChanged extends LoginPageEvent {
  final String value;

  UserNameOrEmailChanged(this.value);

}

class TotpChanged extends LoginPageEvent {
  final String value;

  TotpChanged(this.value);
}

class PasswordChanged extends LoginPageEvent {
  final String value;

  PasswordChanged(this.value);
}

class ServerAddrChanged extends LoginPageEvent {
  final String value;

  ServerAddrChanged(this.value);
}

class Submitted extends LoginPageEvent {
  final Function() onLoginAccepted;

  Submitted(this.onLoginAccepted);
}