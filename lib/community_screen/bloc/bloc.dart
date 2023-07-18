import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';

part 'state.dart';

class CommunityScreenBloc
    extends Bloc<CommunityScreenEvent, CommunityScreenState> {
  CommunityScreenBloc(
      {this.community, required this.communityId, required this.repo})
      : super(CommunityScreenState(
            communityId: communityId, community: community)) {
    on<Initialize>((event, emit) async {
      if (state.community == null) {
        final community = await repo.lemmyRepo.communityFromId(communityId);

        emit(state.copyWith(community: community));
      }

      final posts = await repo.lemmyRepo.getPosts(
          communityId: state.communityId, page: state.pagesLoaded + 1);

      emit(state.copyWith(posts: posts));
    });
  }

  final int communityId;
  final LemmyCommunity? community;
  final ServerRepo repo;
}
