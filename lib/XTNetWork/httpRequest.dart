import 'package:dio/dio.dart';
import 'package:xtflutter/XTNetWork/HttpConfig.dart';

class HttpRequest {
  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: HttpConfig.getInstance().baseURL,
      connectTimeout: HttpConfig.getInstance().timeout,
      headers: {
        "xt-platform": HttpConfig.getInstance().platform,
        "device-info": HttpConfig.getInstance().device,
        "xt-token": HttpConfig.getInstance().token,
        "black-box": HttpConfig.getInstance().black,
      });
  static final Dio dio = Dio(baseOptions);

  static Future<T> request<T>(String url, String method,
      Map<String, dynamic> params, Interceptor inter) async {
    // 1.创建单独配置
    final options = Options(method: method);

    // 全局拦截器
    // 创建默认的全局拦截器
    Interceptor dInter = InterceptorsWrapper(onRequest: (options) {
      print("请求拦截");
      return options;
    }, onResponse: (response) {
      print("响应拦截");
      return response;
    }, onError: (err) {
      print("错误拦截");
      return err;
    });
    List<Interceptor> inters = [dInter];

    // 请求单独拦截器
    if (inter != null) {
      inters.add(inter);
    }

    // 统一添加到拦截器中
    dio.interceptors.addAll(inters);

    // 2.发送网络请求
    try {
      Response response =
          await dio.request(url, data: params, options: options);
      print("----------11111------------");
      print(url);
      print(params);
      print(options.toString());
      print(response.request.uri);
      print(response.request.baseUrl);
      print(response.request.path);
      print(response.request.queryParameters);
      print(response.request.method);
      print("----------11111------------");
      return response.data;
    } on DioError catch (e) {
      print("----------11111------------");
      print(e.request.toString());
      print(e.request.method);
      print(e.request.baseUrl);
      print(e.request.path);
      print(e.request.queryParameters);
      print("----------11111------------");
      return Future.error(e);
    }
  }
}
