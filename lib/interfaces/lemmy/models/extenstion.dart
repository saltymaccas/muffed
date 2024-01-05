import 'package:flutter/material.dart';
import 'package:muffed/interfaces/lemmy/client/client.dart';

extension LemmyClientShortHand on BuildContext{
  LemmyClient get lemmy => LemmyClient(this);
}
