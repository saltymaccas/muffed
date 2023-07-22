part of 'bloc.dart';

sealed class GlobalEvent {}

class AccountLoggedIn extends GlobalEvent {
  final LemmyAccountData account;

  AccountLoggedIn(this.account);
}

class UserRequestsLemmyAccountSwitch extends GlobalEvent {
  final int? accountIndex;

  UserRequestsLemmyAccountSwitch(this.accountIndex);
}