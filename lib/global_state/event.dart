part of 'bloc.dart';

sealed class GlobalEvent {}

/// When the user has successfully logged in from the login page
class AccountLoggedIn extends GlobalEvent {
  final LemmyAccountData account;

  AccountLoggedIn(this.account);
}

class UserRequestsLemmyAccountSwitch extends GlobalEvent {
  final int? accountIndex;

  UserRequestsLemmyAccountSwitch(this.accountIndex);
}

class UserRequestsAccountRemoval extends GlobalEvent {

  UserRequestsAccountRemoval(this.index);

  /// The index of the account that should be removed from the global state
  final int index;
}
