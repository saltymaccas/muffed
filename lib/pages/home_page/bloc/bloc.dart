import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/server_repo.dart';

part 'event.dart';
part 'state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({required this.scrollViews})
      : super(HomePageState(scrollViewConfigs: scrollViews)) {
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

  final List<ContentGetter> scrollViews;
}
