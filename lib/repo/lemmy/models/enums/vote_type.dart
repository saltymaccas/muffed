enum LemmyVoteType {
  upVote,
  downVote,
  none;

  static LemmyVoteType fromJson(int? json) {
    switch (json) {
      case 1:
        return LemmyVoteType.upVote;
      case -1:
        return LemmyVoteType.downVote;
      default:
        return LemmyVoteType.none;
    }
  }

  int get asJson {
    switch (this) {
      case LemmyVoteType.upVote:
        return 1;
      case LemmyVoteType.downVote:
        return -1;
      case LemmyVoteType.none:
        return 0;
    }
  }
}
