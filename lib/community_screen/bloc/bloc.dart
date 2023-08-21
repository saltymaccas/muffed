import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class CommunityScreenBloc
    extends Bloc<CommunityScreenEvent, CommunityScreenState> {
  ///
  CommunityScreenBloc(
      {this.community, required this.communityId, required this.repo})
      : super(CommunityScreenState(
            communityId: communityId, communityInfo: community)) {
    on<Initialize>((event, emit) async {
      // get community info

      if (state.communityInfo == null) {
        emit(state.copyWith(communityInfoStatus: CommunityStatus.loading));

        try {
          final community = await repo.lemmyRepo.getCommunity(id: communityId);

          emit(state.copyWith(
              community: community,
              communityInfoStatus: CommunityStatus.success));
        } catch (err) {
          emit(state.copyWith(communityInfoStatus: CommunityStatus.failure));
        }
      } else {
        emit(state.copyWith(communityInfoStatus: CommunityStatus.success));
      }

      // get posts

      emit(state.copyWith(postsStatus: CommunityStatus.loading));

      try {
        final posts = await repo.lemmyRepo.getPosts(
            communityId: state.communityId, page: state.pagesLoaded + 1);

        emit(
            state.copyWith(posts: posts, postsStatus: CommunityStatus.success));
      } catch (err) {
        emit(state.copyWith(postsStatus: CommunityStatus.failure));
      }
    });

    on<ReachedEndOfScroll>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List newPosts = await repo.lemmyRepo.getPosts(
            page: state.pagesLoaded + 1, communityId: state.communityId);

        emit(state.copyWith(
            posts: [...state.posts, ...newPosts],
            isLoading: false,
            pagesLoaded: state.pagesLoaded + 1));
      } catch (err) {
        print(err);
        emit(state.copyWith(isLoading: false));
      }
    }, transformer: droppable());
    on<SortTypeChanged>((event, emit) async {
      emit(state.copyWith(sortType: event.sortType, isLoading: true));

      try {
        final posts = await repo.lemmyRepo.getPosts(
            sortType: event.sortType, communityId: state.communityId, page: 1);
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
  }

  final int communityId;
  final LemmyCommunity? community;
  final ServerRepo repo;
}
