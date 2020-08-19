import 'package:dio/dio.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/local/helper.dart' as local;

class XTErrorCode extends DioError {
  int errorCode = 0;
}

class HttpRequest {
  static Future<T> request<T>(String url,
      {String method = "get",
      Map<String, dynamic> params,
      Map<String, dynamic> queryParameters,
      Interceptor inter}) async {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: AppConfig.getInstance().baseURL,
      connectTimeout: AppConfig.getInstance().timeout,
    );

    Dio dio = Dio(baseOptions);
    local.helper(dio);
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
      Response response = await dio.request(url,
          data: params, queryParameters: queryParameters, options: options);
      print("----------response start ------------");
      // print(url);
      // print(params.toString());
      // print(options.toString());
      // xtprintRequest(response.request);
      print(response.data.toString());
      print("----------response end ------------");
      Map map = response.data as Map<String, dynamic>;
      if (map["success"] == false) {
        XTErrorCode err = XTErrorCode();
        err.type = DioErrorType.DEFAULT;
        err.error = map["message"];
        err.errorCode = map["code"];
        return Future.error(err);
      } else {
        return response.data;
      }
    } on XTErrorCode catch (e) {
      print("----------response error start1 ------------");
      print("----------response error start1 ------------");
      print("----------response error end------------");
      return Future.error(e);
    }
  }

  static void xtprintRequest(RequestOptions request) {
    // print(request.uri);
    // print(request.baseUrl);
    // print(request.path);
    // print(request.queryParameters);
    // print(request.method);
    // print(request.headers.toString());
  }

  static Future<T> requestOnly<T>(String url, {String method = "get"}) async {
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: AppConfig.getInstance().timeout,
    );
    Dio dio = Dio(baseOptions);
    local.helper(dio);
    final options = Options(method: method, headers: {
      "xt-platform": AppConfig.getInstance().platform,
      "device-info": AppConfig.getInstance().device,
      "xt-token": AppConfig.getInstance().token,
      "black-box": AppConfig.getInstance().black,
    });

    try {
      Response response = await dio.request(url, options: options);
      return response.data;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
