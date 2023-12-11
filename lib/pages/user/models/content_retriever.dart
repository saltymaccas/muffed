import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

class UserContentRetriever
    extends ContentRetriever<LemmyGetPersonDetailsResponse> {
  UserContentRetriever({
    required this.repo,
    this.userId,
    this.username,
  }) : assert(userId != null || username != null, 'no user was provided');

  final int? userId;
  final String? username;
  final ServerRepo repo;

  @override
  Future<List<LemmyGetPersonDetailsResponse>> call({int page = 1}) async {
    final response = await repo.lemmyRepo.getPersonDetails(
      id: userId,
      username: username,
      page: page,
    );

    return [response];
  }

  @override
  bool hasReachedEnd(List<LemmyGetPersonDetailsResponse> content) =>
      content.last.posts.isEmpty && content.last.comments.isEmpty;
}
