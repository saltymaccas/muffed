part of 'bloc.dart';

class InboxItemState extends Equatable {
  const InboxItemState({required this.read, this.exception});

  final bool read;
  final MException? exception;

  @override
  List<Object?> get props => [read, exception];

  InboxItemState copyWith({bool? read, MException? exception}) {
    return InboxItemState(
      read: read ?? this.read,
      exception: exception,
    );
  }
}
