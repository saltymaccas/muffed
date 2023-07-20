part of 'bloc.dart';

sealed class CommunityScreenEvent {}

class Initialize extends CommunityScreenEvent {}

class ReachedEndOfScroll extends CommunityScreenEvent {}