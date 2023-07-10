part of 'bloc.dart';

enum ContentScreenStatus { initial, loading, success, failure }

class ContentScreenState extends Equatable{
  final ContentScreenStatus status;
  final List<LemmyComment>? comments;


  ContentScreenState({required this.status, this.comments});


  @override
  List<Object?> get props => [status, comments];
}