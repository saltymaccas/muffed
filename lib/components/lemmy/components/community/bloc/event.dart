part of 'bloc.dart';

sealed class CommunityScreenEvent {}

class InitialiseCommunityScreen extends CommunityScreenEvent {}

class ToggledSubscribe extends CommunityScreenEvent {}

class BlockToggled extends CommunityScreenEvent {}
