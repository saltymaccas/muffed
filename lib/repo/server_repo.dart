import 'package:muffed/global_state/bloc.dart';
import 'lemmy.dart';

export 'lemmy/models.dart';

interface class ServerRepo {
  final LemmyRepo lemmyRepo;
  final GlobalBloc globalBloc;

  ServerRepo(this.globalBloc) : lemmyRepo = LemmyRepo(globalBloc: globalBloc);
}


