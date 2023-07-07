import 'lemmy.dart';
import 'lemmy/models.dart';

interface class ServerApi {
  final LemmyApi lemmyApi;

  ServerApi() : lemmyApi = LemmyApi();

  Future<List> getPosts({LemmySortType sortType = LemmySortType.hot, int page = 1}) async {
    return await lemmyApi.getPosts(sortType: sortType, page: page);
  }
}