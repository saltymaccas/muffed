part of 'bloc.dart';

sealed class UserScreenEvent {}

class InitializeEvent extends UserScreenEvent {}

class ReachedNearEndOfScroll extends UserScreenEvent {}
