part of 'bloc.dart';

sealed class AddKeyEvent {}

class Submitted extends AddKeyEvent {
  Submitted({
    required this.instanceAddress,
    required this.authenticate,
  });
  final bool authenticate;
  final String instanceAddress;
}
