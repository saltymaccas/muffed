import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// A class to hold and interpet any exception,
///
/// Should not be used to throw an error only to hold and interpret the error
/// afterwards.
class MException {
  MException(this.exception, this.stackTrace);

  /// The exception object.
  ///
  /// Can take any object, the methods in this class are meant to be able to
  /// interet any object that can be passed in here.
  final Object exception;
  final StackTrace? stackTrace;

  void log(Logger logger) {
    logger
      ..severe('Error: $exception')
      ..severe('StackTrace: $stackTrace');
  }

  String exceptionToString() {
    final exc = exception;
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
