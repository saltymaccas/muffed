import '../global_state/bloc.dart';
import 'lemmy.dart';
import 'lemmy/models.dart';
import 'package:dio/dio.dart';

export 'lemmy/models.dart';

interface class ServerRepo {
  final LemmyRepo lemmyRepo;
  final GlobalBloc globalBloc;

  ServerRepo(this.globalBloc) : lemmyRepo = LemmyRepo(globalBloc: globalBloc);

  Future<List> getPosts(
      {LemmySortType sortType = LemmySortType.hot, int page = 1}) async {
    return await lemmyRepo.getPosts(sortType: sortType, page: page);
  }
}


