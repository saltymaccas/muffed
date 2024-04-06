part of 'bloc.dart';

sealed class AddKeyEvent {}

class Submitted extends AddKeyEvent {
  Submitted({
    required this.instanceAddress,
    required this.authenticate,
    required this.username,
    required this.password,
    required this.twoFA,
  });
  final bool authenticate;
  final String instanceAddress;
  final String username;
  final String password;
  final String twoFA;
}
