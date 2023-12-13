enum LemmySearchType {
  all,
  comments,
  posts,
  communities,
  users,
  url;

  static LemmySearchType fromJson(String json) {
    switch (json) {
      case 'All':
        return LemmySearchType.all;
      case 'Comments':
        return LemmySearchType.comments;
      case 'Posts':
        return LemmySearchType.posts;
      case 'Communities':
        return LemmySearchType.communities;
      case 'Users':
        return LemmySearchType.users;
      case 'Url':
        return LemmySearchType.url;
      default:
        throw Exception('Unknown LemmySearchType: $json');
    }
  }

  String get asJson {
    switch (this) {
      case LemmySearchType.all:
        return 'All';
      case LemmySearchType.comments:
        return 'Comments';
      case LemmySearchType.posts:
        return 'Posts';
      case LemmySearchType.communities:
        return 'Communities';
      case LemmySearchType.users:
        return 'Users';
      case LemmySearchType.url:
        return 'Url';
    }
  }
}
