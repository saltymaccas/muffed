part of 'bloc.dart';

enum HomePageStatus { initial, success }

class HomePageState extends Equatable {
  const HomePageState({
    this.scrollViewConfigs = const [],
    this.status = HomePageStatus.initial,
  });

  final List<HomePageContentRetriever> scrollViewConfigs;
  final HomePageStatus status;

  @override
  List<Object?> get props => [scrollViewConfigs, status];

  HomePageState copyWith({
    List<HomePageContentRetriever>? scrollViewConfigs,
    HomePageStatus? status,
  }) {
    return HomePageState(
      scrollViewConfigs: scrollViewConfigs ?? this.scrollViewConfigs,
      status: status ?? this.status,
    );
  }
}
