import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/home/home.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

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
