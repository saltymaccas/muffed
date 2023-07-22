part of 'bloc.dart';

sealed class GlobalEvent {}

class AccountLoggedIn extends GlobalEvent {
  final LemmyAccountData account;

  AccountLoggedIn(this.account);
}