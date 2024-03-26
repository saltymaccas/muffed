import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'state.dart';
part 'event.dart';
part 'bloc.freezed.dart';
part 'bloc.g.dart';

class LemmyKeychainBloc
    extends HydratedBloc<LemmyKeychainEvent, LemmyKeychainState> {
  LemmyKeychainBloc()
      : super(
          LemmyKeychainState(
              keys: [LemmyKey(instanceAddress: 'sh.itjust.works')],
              activeKeyIndex: 0),
        ) {}

  @override
  LemmyKeychainState fromJson(Map<String, Object?> json) =>
      LemmyKeychainState.fromJson(json);

  @override
  Map<String, Object?> toJson(LemmyKeychainState state) => state.toJson();
}
