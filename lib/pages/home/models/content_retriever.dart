import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

abstract class HomePageContentRetriever<Data>
    extends ContentRetrieverDelegate<Data> {
  const HomePageContentRetriever({required this.title});

  final String title;
}

class LemmyPostRetriever extends HomePageContentRetriever<LemmyPost> {
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
  Future<List<LemmyPost>> retrieveContent({required int page}) {
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
