import 'package:equatable/equatable.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

abstract class HomePageContentRetriever extends ContentRetriever
    with EquatableMixin {
  const HomePageContentRetriever({required this.title});

  final String title;
}

class LemmyPostRetriever extends HomePageContentRetriever {
  const LemmyPostRetriever({
    required super.title,
    required this.listingType,
    required this.sortType,
    required this.repo,
  });

  final LemmySortType sortType;
  final LemmyListingType listingType;
  final ServerRepo repo;

  @override
  Future<List<Object>> call({required int page}) {
    return repo.lemmyRepo
        .getPosts(page: page, listingType: listingType, sortType: sortType);
  }

  @override
  List<Object?> get props => [
        super.title,
        sortType,
        listingType,
        repo,
      ];

  LemmyPostRetriever copyWith({
    String? title,
    LemmySortType? sortType,
    LemmyListingType? listingType,
    ServerRepo? repo,
  }) {
    return LemmyPostRetriever(
      title: title ?? this.title,
      sortType: sortType ?? this.sortType,
      listingType: listingType ?? this.listingType,
      repo: repo ?? this.repo,
    );
  }
}
