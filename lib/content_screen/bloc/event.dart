part of 'bloc.dart';

sealed class ContentScreenEvent {}

final class InitializeEvent extends ContentScreenEvent{}

final class ReachedNearEndOfScroll extends ContentScreenEvent {}