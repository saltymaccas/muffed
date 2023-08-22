part of 'bloc.dart';

sealed class GlobalEvent {}

/// When the user has successfully logged in from the login page
class AccountLoggedIn extends GlobalEvent {
  final LemmyAccountData account;

  AccountLoggedIn(this.account);
}

class UserRequestsLemmyAccountSwitch extends GlobalEvent {
  final int accountIndex;

  UserRequestsLemmyAccountSwitch(this.accountIndex);
}

class UserRequestsAccountRemoval extends GlobalEvent {
  UserRequestsAccountRemoval(this.index);

  /// The index of the account that should be removed from the global state
  final int index;
}

class ThemeModeChanged extends GlobalEvent {
  ThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;
}

class UseDynamicColorSchemeChanged extends GlobalEvent {
  UseDynamicColorSchemeChanged(this.useDynamicColorScheme);

  final bool useDynamicColorScheme;
}

class SeedColorChanged extends GlobalEvent {
  SeedColorChanged(this.seedColor);

  final Color seedColor;
}

final class ShowNsfwChanged extends GlobalEvent {
  ShowNsfwChanged(this.value);

  final bool value;
}

final class BlurNsfwChanged extends GlobalEvent {
  BlurNsfwChanged(this.value);

  final bool value;
}
