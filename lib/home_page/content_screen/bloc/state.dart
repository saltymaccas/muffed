part of 'bloc.dart';

enum ContentScreenStatus { initial, loading, success, failure }

class ContentScreenState extends Equatable{
  final ContentScreenStatus status;


  ContentScreenState({required this.status});


  @override
  List<Object?> get props => [];
}