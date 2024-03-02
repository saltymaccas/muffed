import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/widgets/content_scroll_view/content_scroll_view.dart';

/// Defines the method for retrieving the community posts and retrieves them
/// when called.
class CommunityScreenContentRetriever extends ContentRetriever
    with EquatableMixin {
  const CommunityScreenContentRetriever({
    required this.sortType,
    required this.context,
    this.communityId,
    this.communityName,
  }) : assert(
          communityId != null || communityName != null,
          'No community defined',
        );

  final LemmySortType sortType;
  final BuildContext context;
  final int? communityId;
  final String? communityName;

  @override
  Future<List<Object>> call({required int page}) {
    return context.read<ServerRepo>().lemmyRepo.getPosts(
          page: page,
          communityId: communityId,
          sortType: sortType,
        );
  }

  @override
  List<Object?> get props => [sortType, context, communityId];

  CommunityScreenContentRetriever copyWith({
    LemmySortType? sortType,
    BuildContext? context,
    int? communityId,
  }) {
    return CommunityScreenContentRetriever(
      sortType: sortType ?? this.sortType,
      context: context ?? this.context,
      communityId: communityId ?? this.communityId,
    );
  }
}
