part of 'bloc.dart';

///
sealed class LoginPageEvent {}

///
class UserNameOrEmailChanged extends LoginPageEvent {
  ///
  UserNameOrEmailChanged(this.value);

  ///
  final String value;
}

///
class TotpChanged extends LoginPageEvent {
  ///
  TotpChanged(this.value);

  ///
  final String value;
}

///
class PasswordChanged extends LoginPageEvent {
  ///
  PasswordChanged(this.value);

  ///
  final String value;
}

///
class ServerAddressChanged extends LoginPageEvent {
  ///
  ServerAddressChanged(this.value);

  ///
  final String value;
}

/// When the user presses "Login" on the login page
class Submitted extends LoginPageEvent {
  ///
  Submitted(this.onLoginAccepted);

  /// A function the UI wants to run if the login finishes successfully
  final void Function() onLoginAccepted;
}

class RevealPasswordToggled extends LoginPageEvent {}
