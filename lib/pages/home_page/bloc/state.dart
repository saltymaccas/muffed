part of 'bloc.dart';

class ContentScrollConfig extends Equatable {
  const ContentScrollConfig({
    required this.title,
    required this.retrieveContentFunction,
  });

  final String title;
  final RetrieveContent retrieveContentFunction;

  @override
  List<Object?> get props => [title, retrieveContentFunction];
}

class HomePageState extends Equatable {
  const HomePageState({this.scrollViews = const []});

  final List<ContentScrollConfig> scrollViews;

  @override
  List<Object?> get props => [scrollViews];

  HomePageState copyWith({
    List<ContentScrollConfig>? scrollViews,
  }) {
    return HomePageState(
      scrollViews: scrollViews ?? this.scrollViews,
    );
  }
}
