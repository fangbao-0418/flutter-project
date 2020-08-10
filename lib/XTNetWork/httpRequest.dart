import 'package:dio/dio.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';

class HttpRequest {
  static Future<T> request<T>(String url,
      {String method = "get",
      Map<String, dynamic> params,
      Interceptor inter}) async {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: AppConfig.getInstance().baseURL,
      connectTimeout: AppConfig.getInstance().timeout,
    );
    Dio dio = Dio(baseOptions);
    // 1.网络配置
    final options = Options(method: method, headers: {
      "xt-platform": AppConfig.getInstance().platform,
      "device-info": AppConfig.getInstance().device,
      "xt-token": AppConfig.getInstance().token,
      "black-box": AppConfig.getInstance().black,
    });
    // 拦截器
    Interceptor dInter = InterceptorsWrapper(onRequest: (options) {
      print("请求拦截");
      return options;
    }, onResponse: (response) {
      print("响应拦截");
      return response;
    }, onError: (err) {
      print(options.headers.toString());
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
      print("----------response start ------------");
      print(url);
      print(params.toString());
      print(options.toString());
      xtprintRequest(response.request);
      print(response.data.toString());
      print("----------response end ------------");
      return response.data;
    } on DioError catch (e) {
      print("----------response error start ------------");
      xtprintRequest(e.request);
      print("----------response error end------------");
      return Future.error(e);
    }
  }

  static void xtprintRequest(RequestOptions request) {
    print(request.uri);
    print(request.baseUrl);
    print(request.path);
    print(request.queryParameters);
    print(request.method);
    print(request.headers.toString());
  }
}
