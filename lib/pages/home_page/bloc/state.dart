part of 'bloc.dart';

abstract class ContentGetter extends Equatable {
  const ContentGetter({required this.title});

  final String title;

  Future<List<Object>> call({required int page});
}

class LemmyPostGetter extends ContentGetter {
  const LemmyPostGetter({
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
  List<Object?> get props =>
      [
        super.title,
        sortType,
        listingType,
        repo,
      ];

  LemmyPostGetter copyWith({
    String? title,
    LemmySortType? sortType,
    LemmyListingType? listingType,
    ServerRepo? repo,
  }) {
    return LemmyPostGetter(
      title: title ?? this.title,
      sortType: sortType ?? this.sortType,
      listingType: listingType ?? this.listingType,
      repo: repo ?? this.repo,
    );
  }
}

class HomePageState extends Equatable {
  const HomePageState({this.scrollViewConfigs = const []});

  final List<ContentGetter> scrollViewConfigs;

  @override
  List<Object?> get props => [scrollViewConfigs];

  HomePageState copyWith({
    List<ContentGetter>? scrollViewConfigs,
  }) {
    return HomePageState(
      scrollViewConfigs: scrollViewConfigs ?? this.scrollViewConfigs,
    );
  }
}
