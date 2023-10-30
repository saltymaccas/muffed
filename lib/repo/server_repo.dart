import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/pictrs.dart';

import 'lemmy.dart';

export 'lemmy/models.dart';

interface class ServerRepo {
  /// Creates a new instance of [ServerRepo].
  ServerRepo(this.globalBloc)
      : lemmyRepo = LemmyRepo(globalBloc: globalBloc),
        pictrsRepo = PictrsRepo(globalBloc: globalBloc);

  final LemmyRepo lemmyRepo;
  final GlobalBloc globalBloc;

  final PictrsRepo pictrsRepo;
}
