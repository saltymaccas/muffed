import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

/// Defines the method for retrieving the community posts and retrieves them
/// when called.
class CommunityScreenContentRetriever extends ContentRetriever
    with EquatableMixin {
  const CommunityScreenContentRetriever({
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
  Future<List<Object>> call({required int page}) {
    return repo.lemmyRepo.getPosts(
      page: page,
      communityId: communityId,
      sortType: sortType,
    );
  }

  @override
  List<Object?> get props => [sortType, repo, communityId];

  CommunityScreenContentRetriever copyWith({
    LemmySortType? sortType,
    ServerRepo? repo,
    int? communityId,
  }) {
    return CommunityScreenContentRetriever(
      sortType: sortType ?? this.sortType,
      repo: repo ?? this.repo,
      communityId: communityId ?? this.communityId,
    );
  }
}
