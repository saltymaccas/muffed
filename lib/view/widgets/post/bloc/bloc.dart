import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';

part 'bloc.freezed.dart';
part 'event.dart';
part 'state.dart';

final _log = Logger('PostItemBloc');

class PostBloc extends Bloc<PostItemEvent, PostState> {
  PostBloc({
    required LemmyRepo lemmyRepo,
    required PostView post,
  })  : lem = lemmyRepo,
        super(PostState(status: PostStatus.idle, post: post));

  final LemmyRepo lem;
}
