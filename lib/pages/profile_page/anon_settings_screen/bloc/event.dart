part of 'bloc.dart';

sealed class AnonSettingsEvent {}

class UrlTextFieldChanged extends AnonSettingsEvent {
  UrlTextFieldChanged(this.text);

  final String text;
}

class SaveRequested extends AnonSettingsEvent {}
