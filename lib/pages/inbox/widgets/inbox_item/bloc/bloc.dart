import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:logging/logging.dart';
import 'package:muffed/exception/exception.dart';
import 'package:muffed/interfaces/lemmy/client/client.dart';

part 'event.dart';
part 'state.dart';

// final _log = Logger('InboxItemBloc');

// abstract class InboxItemBloc extends Bloc<InboxItemEvent, InboxItemState> {
//   InboxItemBloc({required bool read, required this.lem})
//       : super(InboxItemState(read: read)) {
//     on<ReadStatusToggled>(onReadStatusToggled, transformer: restartable());
//   }

//   Future<void> onReadStatusToggled(
//     ReadStatusToggled event,
//     Emitter<InboxItemState> emit,
//   );

//   final LemmyClient lem;
// }

// class ReplyItemBloc extends InboxItemBloc {
//   ReplyItemBloc({required this.item, required super.lem})
//       : super(read: item.read);

//   @override
//   Future<void> onReadStatusToggled(
//     ReadStatusToggled event,
//     Emitter<InboxItemState> emit,
//   ) async {
//     emit(super.state.copyWith(read: !super.state.read));
//     try {
//       await super.lem.markCommentReplyAsRead(
//             commentReplyId: item.id,
//             read: super.state.read,
//           );
//     } catch (exc, stackTrace) {
//       final exception = MException(exc, stackTrace)..log(_log);
//       emit(state.copyWith(read: !super.state.read, exception: exception));
//     }
//   }

//   final CommentReply item;
// }

// class MentionItemBloc extends InboxItemBloc {
//   MentionItemBloc({required this.item, required super.lem})
//       : super(read: false);

//   @override
//   Future<void> onReadStatusToggled(
//     ReadStatusToggled event,
//     Emitter<InboxItemState> emit,
//   ) async {
//     emit(super.state.copyWith(read: !super.state.read));
//     try {
//       // await super
//       //     .lem.markCommentReplyAsRead( read: super.state.read);
//     } catch (exc, stackTrace) {
//       final exception = MException(exc, stackTrace)..log(_log);
//       emit(state.copyWith(read: !super.state.read, exception: exception));
//     }
//   }

//   final InboxMentionItem item;
// }
