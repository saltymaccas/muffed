import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

/// Defines the method for retrieving the community posts and retrieves them
/// when called.
class CommunityScreenPostRetrieverDelegate
    extends ContentRetrieverDelegate<LemmyPost> {
  const CommunityScreenPostRetrieverDelegate({
    required this.sortType,
    required this.repo,
    this.communityId,
    this.communityName,
  }) : assert(
          communityId != null || communityName != null,
          'No community defined',
        );

  final LemmySortType sortType;
  final ServerRepo repo;
  final int? communityId;
  final String? communityName;

  @override
  Future<List<LemmyPost>> retrieveContent({required int page}) {
    return repo.lemmyRepo.getPosts(
      page: page,
      communityId: communityId,
      sortType: sortType,
    );
  }

  @override
  List<Object?> get props => [sortType, repo, communityId];

  CommunityScreenPostRetrieverDelegate copyWith({
    LemmySortType? sortType,
    ServerRepo? repo,
    int? communityId,
  }) {
    return CommunityScreenPostRetrieverDelegate(
      sortType: sortType ?? this.sortType,
      repo: repo ?? this.repo,
      communityId: communityId ?? this.communityId,
    );
  }
}
