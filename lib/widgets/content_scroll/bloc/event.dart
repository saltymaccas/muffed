part of 'bloc.dart';

sealed class ContentScrollEvent {}

final class LoadInitialItems extends ContentScrollEvent {}

final class PullDownRefresh extends ContentScrollEvent {}

final class NearScrollEnd extends ContentScrollEvent {}

final class RetrieveContentDelegateChanged<Data> extends ContentScrollEvent {
  RetrieveContentDelegateChanged(
    this.newRetrieveContentDelegate, {
    this.persistContent = true,
  });

  final ContentRetrieverDelegate<Data> newRetrieveContentDelegate;

  /// Whether to remove all the content in the list or keep them
  final bool persistContent;
}
