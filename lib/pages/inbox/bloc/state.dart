part of 'bloc.dart';

class InboxState extends Equatable {
  const InboxState({this.showUnreadOnly = true});

  final bool showUnreadOnly;

  @override
  List<Object?> get props => [showUnreadOnly];

  InboxState copyWith({
    bool? showUnreadOnly,
  }) {
    return InboxState(
      showUnreadOnly: showUnreadOnly ?? this.showUnreadOnly,
    );
  }
}
