import 'package:dio/dio.dart';

String? errorObjectToString(Object? error) {
  String? errorString;

  if (error == null) return null;

  print(error.runtimeType);

  if (error is DioException) {
    errorString = error.response?.data.toString() ?? error.message.toString();
  } else if (error is Exception) {
    errorString = error.toString();
  } else if (error is Error) {
    errorString = error.stackTrace.toString();
  } else if (error is String) {
    errorString = error;
  } else {
    errorString = error.toString();
  }

  return errorString.replaceAll(
      RegExp(r'auth=(.*?)(?=&|$)'), '[auth redacted]');
}
