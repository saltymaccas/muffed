import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

class UserContentRetriever
    extends ContentRetrieverDelegate<LemmyGetPersonDetailsResponse> {
  const UserContentRetriever({
    required this.repo,
    this.userId,
    this.username,
  }) : assert(userId != null || username != null, 'no user was provided');

  final int? userId;
  final String? username;
  final ServerRepo repo;

  @override
  Future<List<LemmyGetPersonDetailsResponse>> retrieveContent(
      {int page = 1}) async {
    final response = await repo.lemmyRepo.getPersonDetails(
      id: userId,
      username: username,
      page: page,
    );

    return [response];
  }

  @override
  bool hasReachedEnd({
    required List<LemmyGetPersonDetailsResponse> oldContent,
    required List<LemmyGetPersonDetailsResponse> newContent,
  }) =>
      newContent.first.posts.isEmpty && newContent.first.comments.isEmpty;
}
