enum LemmyCommentSortType {
  hot,
  top,
  latest,
  old;

  static LemmyCommentSortType fromJson(String json) {
    switch (json) {
      case 'Hot':
        return LemmyCommentSortType.hot;
      case 'Top':
        return LemmyCommentSortType.top;
      case 'New':
        return LemmyCommentSortType.latest;
      case 'Old':
        return LemmyCommentSortType.old;
    }
    throw Exception('Unknown LemmyCommentSortType: $json');
  }

  String get asJson {
    switch (this) {
      case LemmyCommentSortType.hot:
        return 'Hot';
      case LemmyCommentSortType.top:
        return 'Top';
      case LemmyCommentSortType.latest:
        return 'New';
      case LemmyCommentSortType.old:
        return 'Old';
    }
  }
}
