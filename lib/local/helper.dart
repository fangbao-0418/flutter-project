import 'package:dio/adapter.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'proxy.dart';
import 'package:xtflutter/Utils/Global.dart';

void helper(Dio dio) {
  if (Global.isDebugger) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        return localProxy;
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }
}
