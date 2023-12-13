enum LemmyListingType {
  all,
  local,
  community,
  subscribed;

  static LemmyListingType fromJson(String json) {
    switch (json) {
      case 'All':
        return LemmyListingType.all;
      case 'Local':
        return LemmyListingType.local;
      case 'Community':
        return LemmyListingType.community;
      case 'Subscribed':
        return LemmyListingType.subscribed;
      default:
        throw Exception('Unknown LemmyListingType: $json');
    }
  }

  String get asJson {
    switch (this) {
      case LemmyListingType.all:
        return 'All';
      case LemmyListingType.local:
        return 'Local';
      case LemmyListingType.community:
        return 'Community';
      case LemmyListingType.subscribed:
        return 'Subscribed';
    }
  }
}
