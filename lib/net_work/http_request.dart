import 'package:dio/dio.dart';
import 'package:xtflutter/net_work/local/proxy.dart';
import 'package:xtflutter/utils/Report.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/utils/error/error.dart';
import 'package:xtflutter/net_work/local/helper.dart' as local;

class HttpRequest {
  static Future<T> request<T>(String url,
      {String method = "get", //默认请求方式
      bool hideToast = true, //每一个请求返回的数据 message 是否要toast
      bool hideErrorToast = true, //每一个请求失败之后返回的数据 message 是否要toast
      bool hideSuccessToast = true, //每一个请求成功之后返回的数据 message 是否要toast
      bool processData = true, //进度
      bool noBase = true, //不需要baseUrl ，默认走配置
      bool dealData = true, //是否要处理返回数据  默认处理
      Map<String, dynamic> params, //body 体参数
      Map<String, dynamic> queryParameters, //url 后拼接参数
      Interceptor inter}) async {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: noBase ? AppConfig.getInstance().baseURL : null,
      connectTimeout: AppConfig.getInstance().timeout,
    );

    Dio dio = Dio(baseOptions);
    if (needHttpDebug) {
      local.helper(dio);
    }
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

      if (!dealData) {
        return response.data;
      }

      Map<String, dynamic> map = response.data;
      if (!processData) {
        return response as T;
      }

      if (map["success"] == false) {
        XTNetError xtNetError = XTNetError(
            type: XTNetErrorType.DEFAULT,
            message: map["message"],
            data: map.toString(),
            error: null);
        if (!hideToast || !hideErrorToast) {
          print('show message');
          Toast.showToast(msg: map["message"]);
        }

        return Future.error(xtNetError);
      } else {
        if (!hideToast || !hideSuccessToast) {
          Toast.showToast(msg: map["message"]);
        }
        // var result = map["data"];
        // if (result.runtimeType
        //     .toString()
        //     .contains("_InternalLinkedHashMap<String, dynamic>")) {
        //   return Map.from(result) as T;
        // } else if (result.runtimeType.toString().contains("List")) {
        //   var tl = [];
        //   for (var temp in result) {
        //     if (temp.runtimeType.toString() ==
        //         "_InternalLinkedHashMap<String, dynamic>") {
        //       tl.add(Map.from(temp));
        //     } else {
        //       tl.add(temp);
        //     }
        //   }
        //   return tl as T;
        // }
        return map["data"] as T;
      }
    } catch (e) {
      print("e.toString()--------111111-----------");
      print(e.toString());
      print("e.toString()-------------------");
      XTNetError xtNetError;
      String message = '网络异常';
      if (e is DioError) {
        print(e.type);
        // dio error
        xtNetError = XTNetError(
          dioErrorType: e.type,
          error: null,
          type: XTNetErrorType.DIO_ERROR,
        );

        if (e.type == DioErrorType.DEFAULT) {
          message = '网络异常';
        } else if (e.type == DioErrorType.RESPONSE) {
          xtNetError.data = e.response;
          message = '网络异常';
        } else if (e.type == DioErrorType.CONNECT_TIMEOUT) {
          message = '网络连接超时';
        } else if (e.type == DioErrorType.SEND_TIMEOUT) {
          message = '发送请求超时';
        } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
          message = '数据接收超时';
        } else if (e.type == DioErrorType.CANCEL) {
          //
        }
      } else {
        // syntax error
        // Toast.showToast(msg: '数据处理失败');
        message = '数据处理异常';
        xtNetError = XTNetError(type: XTNetErrorType.SYNTAX_ERROR, error: e);
      }
      xtNetError.message = message;
      if (!hideToast || !hideErrorToast) {
        Toast.showToast(msg: message);
      }
      return Future.error(xtNetError);
    }
  }

  static Future<T> requestOnly<T>(String url, {String method = "get"}) async {
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: AppConfig.getInstance().timeout,
    );
    Dio dio = Dio(baseOptions);
    if (needHttpDebug) {
      local.helper(dio);
    }

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
