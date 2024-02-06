part of 'bloc.dart';

sealed class BlockDialogEvent {}

class InitializeEvent extends BlockDialogEvent {}

class BlockOrUnblockRequested extends BlockDialogEvent {}
