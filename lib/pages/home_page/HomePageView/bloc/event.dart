part of 'bloc.dart';

sealed class HomePageViewEvent {}

final class LoadInitialPostsRequested extends HomePageViewEvent {}

final class PullDownRefresh extends HomePageViewEvent {}

final class ReachedNearEndOfScroll extends HomePageViewEvent {}

final class AccountChanged extends HomePageViewEvent {}

final class SortTypeChanged extends HomePageViewEvent {
  SortTypeChanged(this.sortType);

  final LemmySortType sortType;
}
