import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

final _log = Logger('CommunityScreenBloc');

class CommunityScreenBloc
    extends Bloc<CommunityScreenEvent, CommunityScreenState> {
  ///
  CommunityScreenBloc({
    required this.repo,
    this.community,
    this.communityName,
    this.communityId,
  }) : super(
          CommunityScreenState(
            community: community,
          ),
        ) {
    on<Initialize>((event, emit) async {
      // get community info if none were passed in
      if (state.community == null) {
        emit(
          state.copyWith(
            communityInfoStatus: CommunityStatus.loading,
            fullCommunityInfoStatus: CommunityStatus.loading,
          ),
        );

        try {
          final community = await repo.lemmyRepo
              .getCommunity(id: communityId, name: communityName);

          emit(
            state.copyWith(
              community: community,
              communityInfoStatus: CommunityStatus.success,
            ),
          );
        } catch (err) {
          emit(
            state.copyWith(
              communityInfoStatus: CommunityStatus.failure,
              error: err,
            ),
          );
          rethrow;
        }
      } else {
        emit(state.copyWith(communityInfoStatus: CommunityStatus.success));
      }

      // if community is loaded check if it is fully loaded, if not fully load
      // it
      if (state.communityInfoStatus == CommunityStatus.success) {
        if (!state.community!.isFullyLoaded()) {
          emit(
            state.copyWith(fullCommunityInfoStatus: CommunityStatus.loading),
          );

          try {
            print('test33');

            final community = await repo.lemmyRepo.getCommunity(
              id: state.community!.id,
              name: state.community!.name,
            );

            emit(
              state.copyWith(
                community: community,
                fullCommunityInfoStatus: CommunityStatus.success,
              ),
            );
          } catch (err) {
            emit(
              state.copyWith(
                fullCommunityInfoStatus: CommunityStatus.failure,
                error: err,
              ),
            );
            rethrow;
          }
        } else {
          emit(
            state.copyWith(fullCommunityInfoStatus: CommunityStatus.success),
          );
        }
      }

      // get posts
      emit(state.copyWith(postsStatus: CommunityStatus.loading));

      try {
        final posts = await repo.lemmyRepo.getPosts(
          communityId: state.community!.id,
          page: state.pagesLoaded + 1,
        );

        emit(
          state.copyWith(posts: posts, postsStatus: CommunityStatus.success),
        );
      } catch (err) {
        emit(
          state.copyWith(
            postsStatus: CommunityStatus.failure,
            error: err,
          ),
        );
      }
    });

    on<ReachedEndOfScroll>(
      (event, emit) async {
        if (!state.reachedEnd) {
          emit(state.copyWith(isLoading: true));

          try {
            final newPosts = await repo.lemmyRepo.getPosts(
              page: state.pagesLoaded + 1,
              communityId: state.community!.id,
            );

            if (newPosts.isEmpty) {
              emit(state.copyWith(isLoading: false, reachedEnd: true));
            } else {
              emit(
                state.copyWith(
                  posts: {...state.posts, ...newPosts}.toList(),
                  isLoading: false,
                  pagesLoaded: state.pagesLoaded + 1,
                ),
              );
            }
          } catch (err) {
            emit(state.copyWith(isLoading: false, error: err));
          }
        }
      },
      transformer: droppable(),
    );
    on<SortTypeChanged>((event, emit) async {
      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        final posts = await repo.lemmyRepo.getPosts(
          sortType: event.sortType,
          communityId: state.community!.id,
          page: 1,
        );
        emit(
          state.copyWith(
            isLoading: false,
            loadedSortType: event.sortType,
            pagesLoaded: 1,
            posts: posts,
            reachedEnd: false,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            error: err,
            isLoading: false,
            sortType: state.loadedSortType,
          ),
        );
      }
    });
    on<ToggledSubscribe>((event, emit) async {
      emit(
        state.copyWith(
          community: state.community!.copyWith(
            subscribed: (state.community!.subscribed ==
                    LemmySubscribedType.notSubscribed)
                ? LemmySubscribedType.pending
                : LemmySubscribedType.notSubscribed,
          ),
        ),
      );
      try {
        final result = await repo.lemmyRepo.followCommunity(
          communityId: state.community!.id,
          follow:
              state.community!.subscribed != LemmySubscribedType.notSubscribed,
        );
        emit(
          state.copyWith(
            community: state.community!.copyWith(subscribed: result),
          ),
        );
      } catch (err) {
        emit(state.copyWith(error: err));
      }
    });
    on<PullDownReload>((event, emit) async {
      emit(state.copyWith(isReloading: true));
      try {
        // gets both posts and community info
        final result = await Future.wait([
          repo.lemmyRepo.getPosts(communityId: state.community!.id, page: 1),
          repo.lemmyRepo.getCommunity(id: communityId),
        ]);

        emit(
          state.copyWith(
            community: result[1] as LemmyCommunity,
            posts: result[0] as List<LemmyPost>,
            pagesLoaded: 1,
            isReloading: false,
            reachedEnd: false,
          ),
        );
      } catch (err) {
        emit(state.copyWith(error: err, isReloading: false));
      }
    });
  }

  final String? communityName;
  final int? communityId;
  final LemmyCommunity? community;
  final ServerRepo repo;

  @override
  void onChange(Change<CommunityScreenState> change) {
    super.onChange(change);
    _log.fine(change);
  }

  @override
  void onTransition(
    Transition<CommunityScreenEvent, CommunityScreenState> transition,
  ) {
    super.onTransition(transition);
    _log.fine(transition);
  }
}
