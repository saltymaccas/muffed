import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState>{
  ContentScreenBloc() : super(ContentScreenState(status: ContentScreenStatus.initial)){}
}

