import 'package:logging/logging.dart';

/// A class to hold errors and execute methods such as log and humanise message
class MException {
  MException(this.exception, this.stackTrace);

  final Object exception;
  final StackTrace? stackTrace;

  void log(Logger logger) {
    logger
      ..severe('Error: $exception')
      ..severe('StackTrace: $stackTrace');
  }
}
