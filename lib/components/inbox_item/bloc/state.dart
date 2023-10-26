part of 'bloc.dart';

/// InboxItemState
class InboxItemState extends Equatable {
  ///
  InboxItemState({this.voteType = LemmyVoteType.none});

  final LemmyVoteType voteType;

  @override
  List<Object> get props => [voteType];
}
