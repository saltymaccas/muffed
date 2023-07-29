part of 'bloc.dart';

sealed class HomePageEvent {}

final class LoadInitialPostsRequested extends HomePageEvent {}

final class PullDownRefresh extends HomePageEvent {}

final class ReachedNearEndOfScroll extends HomePageEvent {}

final class AccountChanged extends HomePageEvent{}

final class ListingTypeChanged extends HomePageEvent{

  ListingTypeChanged(this.listingType);

  final LemmyListingType listingType;
}

final class SortTypeChanged extends HomePageEvent{

  SortTypeChanged(this.sortType);

  final LemmySortType sortType;
}
