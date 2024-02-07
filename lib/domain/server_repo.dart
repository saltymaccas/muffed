import 'package:muffed/domain/global_state/bloc.dart';
import 'package:muffed/domain/lemmy.dart';
import 'package:muffed/domain/pictrs.dart';

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
