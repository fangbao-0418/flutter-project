import 'package:dio/adapter.dart';
import 'dart:io';
import '../XTNetWork/HttpConfig.dart';
import '../XTNetWork/httpRequest.dart';

void helper () {
  const jsModel = {
    "platform": "h5",
    "device": "ios",
    "baseURL": "https://youxuan-api.hzxituan.com/",
    "token": "eyJhbGciOiJIUzUxMiJ9.eyJ0aW1lIjoxNTk2Njc3OTk1MTIwLCJwbGF0Zm9ybSI6Img1IiwibWVtYmVySWQiOjY0NDIwMX0.puVbHP67ItVS3GZ_s7HxoMu6vNYS4Kn_HbQH-bj-tkjaMoOBwH9emq4XMhU7Q_IjI5yFTgpTdkk3CZamJE5hhQ"
  };

  HttpConfig.getInstance().updateConfig(
  jsModel["baseURL"],
  jsModel["device"],
  jsModel["black"],
  jsModel["token"],
  jsModel["platform"]);
  var dio = HttpRequest.dio;
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.findProxy = (uri) {
        return "PROXY 192.168.124.10:58221";
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  };
}
  