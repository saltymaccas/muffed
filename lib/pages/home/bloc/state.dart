part of 'bloc.dart';

enum HomePageStatus { initial, success }

class HomePageState extends Equatable {
  const HomePageState({
    this.scrollViewConfigs = const [],
    this.status = HomePageStatus.initial,
    this.currentPage = 0,
  });

  final List<HomePageContentRetriever> scrollViewConfigs;
  final HomePageStatus status;
  final int currentPage;

  HomePageContentRetriever get currentScrollViewConfig =>
      scrollViewConfigs[currentPage];

  @override
  List<Object?> get props => [currentPage, scrollViewConfigs, status];

  HomePageState copyWith({
    List<HomePageContentRetriever>? scrollViewConfigs,
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
