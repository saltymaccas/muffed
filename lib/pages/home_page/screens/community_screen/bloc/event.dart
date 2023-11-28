part of 'bloc.dart';

sealed class CommunityScreenEvent {}

class Initialize extends CommunityScreenEvent {}

class ToggledSubscribe extends CommunityScreenEvent {}

class BlockToggled extends CommunityScreenEvent {}
