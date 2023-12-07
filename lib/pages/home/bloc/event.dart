part of 'bloc.dart';

sealed class HomePageEvent {
  const HomePageEvent();
}

class SortTypeChanged extends HomePageEvent {
  SortTypeChanged({required this.pageIndex, required this.newSortType});

  final int pageIndex;
  final LemmySortType newSortType;
}

class Initialise extends HomePageEvent {
  const Initialise({required this.isLoggedIn, required this.repo});

  final ServerRepo repo;

  final bool isLoggedIn;
}

class PageChanged extends HomePageEvent {
  const PageChanged({required this.newPageIndex});

  final int newPageIndex;
}
