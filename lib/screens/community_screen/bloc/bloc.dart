import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class CommunityScreenBloc
    extends Bloc<CommunityScreenEvent, CommunityScreenState> {
  ///
  CommunityScreenBloc({
    this.community,
    required this.communityId,
    required this.repo,
  }) : super(
          CommunityScreenState(
            communityId: communityId,
            community: community,
          ),
        ) {
    on<Initialize>((event, emit) async {
      // get community info if none was passed in
      if (state.community == null) {
        emit(state.copyWith(communityInfoStatus: CommunityStatus.loading));

        try {
          final community = await repo.lemmyRepo.getCommunity(id: communityId);

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
              errorMessage: err,
            ),
          );
        }
      } else {
        emit(state.copyWith(communityInfoStatus: CommunityStatus.success));
      }

      // get posts
      emit(state.copyWith(postsStatus: CommunityStatus.loading));

      try {
        final posts = await repo.lemmyRepo.getPosts(
          communityId: state.communityId,
          page: state.pagesLoaded + 1,
        );

        emit(
          state.copyWith(posts: posts, postsStatus: CommunityStatus.success),
        );
      } catch (err) {
        emit(
          state.copyWith(
            postsStatus: CommunityStatus.failure,
            errorMessage: err,
          ),
        );
      }
    });

    on<ReachedEndOfScroll>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true));

        try {
          final newPosts = await repo.lemmyRepo.getPosts(
            page: state.pagesLoaded + 1,
            communityId: state.communityId,
          );

          emit(
            state.copyWith(
              posts: {...state.posts, ...newPosts}.toList(),
              isLoading: false,
              pagesLoaded: state.pagesLoaded + 1,
            ),
          );
        } catch (err) {
          emit(state.copyWith(isLoading: false, errorMessage: err));
        }
      },
      transformer: droppable(),
    );
    on<SortTypeChanged>((event, emit) async {
      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        final posts = await repo.lemmyRepo.getPosts(
          sortType: event.sortType,
          communityId: state.communityId,
          page: 1,
        );
        emit(
          state.copyWith(
            isLoading: false,
            loadedSortType: event.sortType,
            pagesLoaded: 1,
            posts: posts,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(
            errorMessage: err,
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
          communityId: state.communityId,
          follow:
              state.community!.subscribed != LemmySubscribedType.notSubscribed,
        );
        emit(
          state.copyWith(
            community: state.community!.copyWith(subscribed: result),
          ),
        );
      } catch (err) {
        emit(state.copyWith(errorMessage: err));
      }
    });
  }

  final int communityId;
  final LemmyCommunity? community;
  final ServerRepo repo;
}
