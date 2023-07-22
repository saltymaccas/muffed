part of 'bloc.dart';

sealed class GlobalEvent {}

class AccountLoggedIn extends GlobalEvent {
  final AccountData account;

  AccountLoggedIn(this.account);
}