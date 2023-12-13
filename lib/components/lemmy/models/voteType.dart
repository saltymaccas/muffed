enum voteType { upVote, downVote, none }

Map<voteType, int> lemmyVoteTypeJson = {
  voteType.upVote: 1,
  voteType.none: 0,
  voteType.downVote: -1,
};

Map<int, voteType> jsonToLemmyVoteType = {
  1: voteType.upVote,
  0: voteType.none,
  -1: voteType.downVote,
};
