import 'dart:convert';

String makeRouter(bool isNative, Map argument, String url) {
  var map = {"native": isNative, "arg": argument, "url": url};
  var result = json.encode(map);
  return result;
}
