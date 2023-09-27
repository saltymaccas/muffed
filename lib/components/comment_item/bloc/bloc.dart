import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/repo/lemmy/models.dart';

part 'event.dart';
part 'state.dart';

class CommentItemBloc extends Bloc<CommentItemEvent, CommentItemState> {
  ///
  CommentItemBloc({required this.comment})
      : super(CommentItemState(comment: comment)) {}

  final LemmyComment comment;
}
