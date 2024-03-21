import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/view/widgets/comment/models/models.dart';

part 'bloc.freezed.dart';
part 'event.dart';
part 'state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({required CommentTree commentTree})
      : super(
          CommentState(
            comment: commentTree.comment,
            children: commentTree.children,
            level: commentTree.level,
          ),
        );
}
