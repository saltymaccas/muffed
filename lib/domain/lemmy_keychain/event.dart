part of 'bloc.dart';

sealed class LemmyKeychainEvent {}

class SiteRetrieved extends LemmyKeychainEvent {}

class KeyAdded extends LemmyKeychainEvent {
  KeyAdded(this.key);
  final LemmyKey key;
}

class KeyRemoved extends LemmyKeychainEvent {
  KeyRemoved(this.index);

  final int index;
}

class ActiveKeyChanged extends LemmyKeychainEvent {
  ActiveKeyChanged(this.key);

  final LemmyKey key;
}
