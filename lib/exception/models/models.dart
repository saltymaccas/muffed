import 'package:dio/dio.dart';
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

  String exceptionToString() {
    final Object exc = exception;
    String? exceptionString;

    if (exc is DioException) {
      exceptionString = exc.response?.data.toString() ?? exc.message.toString();
    } else if (exc is Exception) {
      exceptionString = exc.toString();
    } else if (exc is String) {
      exceptionString = exc;
    } else {
      exceptionString = exc.toString();
    }

    return exceptionString.replaceAll(
      RegExp(r'auth=(.*?)(?=&|$)'),
      '[auth redacted]',
    );
  }
}
