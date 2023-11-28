import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/widgets/content_scroll_view/bloc/bloc.dart';

part 'event.dart';
part 'state.dart';

abstract class HomePageContentRetriever extends ContentRetriever
    with EquatableMixin {
  const HomePageContentRetriever({required this.title});

  final String title;
}

class LemmyPostGetter extends HomePageContentRetriever {
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
  List<Object?> get props => [
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

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(const HomePageState()) {
    on<Initialise>((event, emit) {
      // defines the scroll views
      final scrollViews = [
        if (event.isLoggedIn)
          LemmyPostGetter(
            title: 'Subscribed',
            sortType: LemmySortType.hot,
            listingType: LemmyListingType.subscribed,
            repo: event.repo,
          ),
        LemmyPostGetter(
          title: 'Popular',
          sortType: LemmySortType.hot,
          listingType: LemmyListingType.all,
          repo: event.repo,
        ),
      ];

      emit(
        state.copyWith(
          status: HomePageStatus.success,
          scrollViewConfigs: scrollViews,
        ),
      );
    });

    on<SortTypeChanged>((event, emit) {
      final newScrollViewConfigs = [...state.scrollViewConfigs];

      final newScrollConfig = newScrollViewConfigs[event.pageIndex];

      if (newScrollConfig is LemmyPostGetter) {
        newScrollViewConfigs[event.pageIndex] = newScrollConfig.copyWith(
          sortType: event.newSortType,
        );
      } else {
        throw 'Expected LemmyPostGetterType got ${newScrollConfig.runtimeType}';
      }

      emit(state.copyWith(scrollViewConfigs: newScrollViewConfigs));
    });
  }
}
