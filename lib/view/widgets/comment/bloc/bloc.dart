import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/view/widgets/comment/models/models.dart';

part 'state.dart';
part 'event.dart';
part 'bloc.freezed.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({required CommentTree commentTree})
      : super(CommentState(commentTree: commentTree));
}
