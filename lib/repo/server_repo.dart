import 'lemmy.dart';
import 'lemmy/models.dart';

export 'lemmy/models.dart';

interface class ServerRepo {
  final LemmyRepo lemmyRepo;

  ServerRepo() : lemmyRepo = LemmyRepo();

  Future<List> getPosts(
      {LemmySortType sortType = LemmySortType.hot, int page = 1}) async {
    return await lemmyRepo.getPosts(sortType: sortType, page: page);
  }
}


