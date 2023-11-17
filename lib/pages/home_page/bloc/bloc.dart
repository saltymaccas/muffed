import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/widgets/content_scroll_view/content_scroll_view.dart';

part 'event.dart';
part 'state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({required this.scrollViews})
      : super(HomePageState(scrollViews: scrollViews)) {}

  final List<ContentScrollConfig> scrollViews;
}
