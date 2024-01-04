import 'package:muffed/db/local_store.dart';
import 'package:muffed/repo/lemmy/lemmy.dart';
import 'package:muffed/repo/pictrs/pictrs.dart';

export 'lemmy/models/models.dart';

interface class ServerRepo {
  /// Creates a new instance of [ServerRepo].
  ServerRepo(this.globalBloc)
      : lemmyRepo = LemmyRepo(globalBloc: globalBloc),
        pictrsRepo = PictrsRepo(globalBloc: globalBloc);

  final LemmyRepo lemmyRepo;
  final DB globalBloc;

  final PictrsRepo pictrsRepo;
}
