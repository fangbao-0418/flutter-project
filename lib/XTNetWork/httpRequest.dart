import 'package:dio/dio.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/local/helper.dart' as local;
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/Utils/Error/XtError.dart';

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
      return options;
    }, onResponse: (response) {
      return response;
    }, onError: (err) {
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
      // print(response);
      Map<String, dynamic> map = response.data;
      if (map["success"] == false) {
        // print("1111-------------------------");
        // print("1111-------------------------" + map["message"]);
        XTNetError xtNetError = XTNetError(
            type: XTNetErrorType.DEFAULT,
            message: map["message"],
            data: map,
            error: DioError(
                type: DioErrorType.DEFAULT,
                request: response.request,
                response: response));
        // default error
        // print("1111-------------------------" + xtNetError.message);

        return Future.error(xtNetError);
      } else {
        return response.data;
      }
    } catch (e) {
      XTNetError xtNetError;
      if (e is DioError) {
        // dio error
        xtNetError = XTNetError(
          dioErrorType: e.type,
          error: e,
          type: XTNetErrorType.DIO_ERROR,
        );
        if (e.type == DioErrorType.DEFAULT) {
          Toast.showToast(msg: '网络异常');
        } else if (e.type == DioErrorType.RESPONSE) {
          xtNetError.data = e.response;
          Toast.showToast(msg: '网络异常');
        } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
          Toast.showToast(msg: '网络连接超时');
        } else if (e.type == DioErrorType.SEND_TIMEOUT) {
          Toast.showToast(msg: '发送请求超时');
        } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
          Toast.showToast(msg: '数据接收超时');
        } else if (e.type == DioErrorType.CANCEL) {
          //
        }
      } else {
        // syntax error
        // Toast.showToast(msg: '数据处理失败');
        xtNetError = XTNetError(type: XTNetErrorType.SYNTAX_ERROR, error: e);
      }
      return Future.error(xtNetError);
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
