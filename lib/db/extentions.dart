import 'package:flutter/material.dart';
import 'package:muffed/db/db.dart';

extension BuildContextShortHand on BuildContext {
  DB get db => DB.of(this);
}
