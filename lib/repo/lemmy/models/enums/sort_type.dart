enum LemmySortType {
  active,
  hot,
  latest,
  old,
  topDay,
  topWeek,
  topMonth,
  topYear,
  topAll,
  mostComments,
  newComments,
  topHour,
  topSixHour,
  topTwelveHour;

  static LemmySortType fromJson(String? json) {
    switch (json) {
      case 'Active':
        return LemmySortType.active;
      case 'Hot':
        return LemmySortType.hot;
      case 'New':
        return LemmySortType.latest;
      case 'Old':
        return LemmySortType.old;
      case 'TopDay':
        return LemmySortType.topDay;
      case 'TopWeek':
        return LemmySortType.topWeek;
      case 'TopMonth':
        return LemmySortType.topMonth;
      case 'TopYear':
        return LemmySortType.topYear;
      case 'TopAll':
        return LemmySortType.topAll;
      case 'MostComments':
        return LemmySortType.mostComments;
      case 'NewComments':
        return LemmySortType.newComments;
      case 'TopHour':
        return LemmySortType.topHour;
      case 'TopSixHour':
        return LemmySortType.topSixHour;
      case 'TopTwelveHour':
        return LemmySortType.topTwelveHour;
    }
    throw Exception('Unknown LemmySortType: $json');
  }

  String get asJson {
    switch (this) {
      case LemmySortType.active:
        return 'Active';
      case LemmySortType.hot:
        return 'Hot';
      case LemmySortType.latest:
        return 'New';
      case LemmySortType.old:
        return 'Old';
      case LemmySortType.topDay:
        return 'TopDay';
      case LemmySortType.topWeek:
        return 'TopWeek';
      case LemmySortType.topMonth:
        return 'TopMonth';
      case LemmySortType.topYear:
        return 'TopYear';
      case LemmySortType.topAll:
        return 'TopAll';
      case LemmySortType.mostComments:
        return 'MostComments';
      case LemmySortType.newComments:
        return 'NewComments';
      case LemmySortType.topHour:
        return 'TopHour';
      case LemmySortType.topSixHour:
        return 'TopSixHour';
      case LemmySortType.topTwelveHour:
        return 'TopTwelveHour';
    }
  }
}
