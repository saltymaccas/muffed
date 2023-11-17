part of 'bloc.dart';

enum BlockDialogStatus { initial, loading, success, failure }

class BlockDialogState extends Equatable {
  const BlockDialogState({
    this.status = BlockDialogStatus.initial,
    this.isLoading = false,
    this.error,
    this.isBlocked,
  });

  final bool? isBlocked;
  final Object? error;
  final BlockDialogStatus status;
  final bool isLoading;

  @override
  List<Object?> get props => [isBlocked, error, status, isLoading];

  BlockDialogState copyWith({
    bool? isBlocked,
    Object? error,
    BlockDialogStatus? status,
    bool? isLoading,
  }) {
    return BlockDialogState(
      isBlocked: isBlocked ?? this.isBlocked,
      error: error,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
