enum LemmySubscribedType {
  subscribed,
  notSubscribed,
  pending;

  static LemmySubscribedType? fromJson(String? json) {
    switch (json) {
      case 'Subscribed':
        return LemmySubscribedType.subscribed;
      case 'Pending':
        return LemmySubscribedType.pending;
      case 'NotSubscribed':
        return LemmySubscribedType.notSubscribed;
      case null:
        return null;
      default:
        throw Exception('Unknown LemmySubscribedType: $json');
    }
  }

  String get asJson {
    switch (this) {
      case LemmySubscribedType.subscribed:
        return 'Subscribed';
      case LemmySubscribedType.pending:
        return 'Pending';
      case LemmySubscribedType.notSubscribed:
        return 'NotSubscribed';
    }
  }
}
