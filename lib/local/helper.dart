import 'package:dio/adapter.dart';
import 'dart:io';
import 'package:dio/dio.dart';

void helper (Dio dio) {
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.findProxy = (uri) {
        return "PROXY 192.168.124.10:58221";
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  };
}
  