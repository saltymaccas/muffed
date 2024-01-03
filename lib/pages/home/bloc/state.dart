part of 'bloc.dart';

enum HomePageStatus { initial, success }

class HomePageState extends Equatable {
  const HomePageState({
    this.scrollViewConfigs = const [],
    this.status = HomePageStatus.initial,
    this.currentPage = 0,
  });

  final List<LemmyPostRetriever> scrollViewConfigs;
  final HomePageStatus status;
  final int currentPage;

  LemmyPostRetriever? get currentScrollViewConfig =>
      (scrollViewConfigs.isEmpty) ? null : scrollViewConfigs[currentPage];

  @override
  List<Object?> get props => [currentPage, scrollViewConfigs, status];

  HomePageState copyWith({
    List<LemmyPostRetriever>? scrollViewConfigs,
    HomePageStatus? status,
    int? currentPage,
  }) {
    return HomePageState(
      scrollViewConfigs: scrollViewConfigs ?? this.scrollViewConfigs,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
