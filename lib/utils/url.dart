/// Ensures a protocol is specified
/// adds HTTPS:// to the end if it is not is
/// removes "www." from the start
String cleanseUrl(String url) {
  if (url.startsWith('www.')) {
    url = url.replaceFirst('www.', '');
  }
  if (url.contains(RegExp('https?://'))) {
    return url;
  } else {
    return 'https://$url';
  }
}
