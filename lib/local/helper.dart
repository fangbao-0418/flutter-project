import 'package:dio/adapter.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'proxy.dart';

void helper(Dio dio) {
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.findProxy = (uri) {
      return localProxy;
    };
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  };
}
