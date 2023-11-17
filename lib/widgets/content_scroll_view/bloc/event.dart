part of 'bloc.dart';

sealed class ContentScrollEvent {}

final class Initialise extends ContentScrollEvent {}

final class PullDownRefresh extends ContentScrollEvent {}

final class ReachedNearEndOfScroll extends ContentScrollEvent {}
