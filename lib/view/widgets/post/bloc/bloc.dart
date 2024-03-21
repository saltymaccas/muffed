import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/domain/lemmy.dart';

part 'bloc.freezed.dart';
part 'event.dart';
part 'state.dart';

final _log = Logger('PostBloc');

class PostBloc extends Bloc<PostItemEvent, PostState> {
  PostBloc({
    required LemmyRepo lemmyRepo,
    PostView? post,
    this.postId,
  })  : lem = lemmyRepo,
        assert(postId != null || post != null, 'no post provided to PostBloc'),
        super(PostState(status: PostStatus.idle, post: post)) {
    on<Initialised>(_onInitialised);
  }

  Future<void> _onInitialised(
    Initialised event,
    Emitter<PostState> emit,
  ) async {
    if (state.post == null) {
      emit(state.copyWith(status: PostStatus.loading));
      try {
        final response = await _loadPost();
        emit(state.copyWith(post: response, status: PostStatus.idle));
      } catch (e, s) {
        _log.warning('', e, s);
        emit(
          state.copyWith(
            status: PostStatus.failure,
            errorMessage: _toErrorMessage(e),
          ),
        );
      }
    }
  }

  Future<PostView> _loadPost() async {
    final response = await lem.run(GetPost(id: postId));
    return response.postView;
  }

  String _toErrorMessage(Object e) {
    return 'error of type ${e.runtimeType} occured';
  }

  final LemmyRepo lem;
  final int? postId;
}
