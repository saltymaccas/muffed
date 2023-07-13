part of 'bloc.dart';

final class DynamicNavigationBarState extends Equatable{
  final int selectedItemIndex;
  final List<Widget>? actions;


  DynamicNavigationBarState({required this.selectedItemIndex, this.actions});

  @override
  List<Object?> get props => [selectedItemIndex, actions];
}