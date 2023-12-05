import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

/// Defines how the comments will be retrieved for the [ContentScrollView]
class CommentRetriever extends ContentRetriever with EquatableMixin {
  CommentRetriever({
    required this.postId,
    required this.repo,
    this.sortType = LemmyCommentSortType.hot,
  });

  final int postId;
  final ServerRepo repo;
  final LemmyCommentSortType sortType;

  @override
  Future<List<LemmyComment>> call({required int page}) async {
    return repo.lemmyRepo.getComments(
      postId: postId,
      page: page,
      sortType: sortType,
    );
  }

  @override
  List<Object?> get props => [postId, repo, sortType];

  CommentRetriever copyWith({
    int? postId,
    ServerRepo? repo,
    LemmyCommentSortType? sortType,
  }) {
    return CommentRetriever(
      postId: postId ?? this.postId,
      repo: repo ?? this.repo,
      sortType: sortType ?? this.sortType,
    );
  }
}
