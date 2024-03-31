part of 'bloc.dart';

sealed class LemmyKeychainEvent {}

class SiteRetrieved extends LemmyKeychainEvent {}

class KeyAdded extends LemmyKeychainEvent {
  KeyAdded(this.key);
  final LemmyKey key;
}
