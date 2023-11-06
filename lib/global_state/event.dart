part of 'bloc.dart';

sealed class GlobalEvent {}

/// When the user has successfully logged in from the login page
class AccountLoggedIn extends GlobalEvent {
  final LemmyAccountData account;

  AccountLoggedIn(this.account);
}

class AccountSwitched extends GlobalEvent {
  final int accountIndex;

  AccountSwitched(this.accountIndex);
}

class AccountRemoved extends GlobalEvent {
  AccountRemoved(this.index);

  /// The index of the account that should be removed from the global state
  final int index;
}

class SettingChanged extends GlobalEvent {
  SettingChanged(this.newState);

  final GlobalState newState;
}
