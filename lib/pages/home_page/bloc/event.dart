part of 'bloc.dart';

sealed class HomePageEvent {}

class SortTypeChanged extends HomePageEvent {
  SortTypeChanged({required this.pageIndex, required this.newSortType});

  final int pageIndex;
  final LemmySortType newSortType;
}
