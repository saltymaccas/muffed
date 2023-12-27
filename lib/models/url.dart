// TODO: add validation and other methods

import 'package:equatable/equatable.dart';

/// Holds a https or http url, does not hold any query parameters.
class HttpUrl extends Equatable {
  const HttpUrl._(
    this._url,
  );
  factory HttpUrl.parse(String url) {
    if (!url.contains('https://') && !url.contains('http://')) {
      url = 'https://$url';
    }

    return HttpUrl._(url);
  }

  factory HttpUrl.fromMap(Map<String, dynamic> json) {
    return HttpUrl._(json['url']);
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }

  static bool isValidHttpUrl(String url) {
    return true;
  }

  final String _url;

  String get url => _url;

  @override
  String toString() {
    return url;
  }

  @override
  List<Object> get props => [_url];
}
