part of 'bloc.dart';

sealed class HomePageEvent {}

final class LoadInitialPostsRequested extends HomePageEvent {}

final class PullDownRefresh extends HomePageEvent {}

final class ReachedNearEndOfScroll extends HomePageEvent {}

final class AccountChanged extends HomePageEvent{}
