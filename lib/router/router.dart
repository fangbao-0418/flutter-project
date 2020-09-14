import 'dart:async';
import 'dart:convert';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/pages/normal/wrapper.dart';
import 'package:xtflutter/utils/global.dart';
import 'package:xtflutter/router/routers_map.dart';
import 'package:xtflutter/utils/report.dart';

///原生跳转参数配置
String makeRouter(bool isNative, Map argument, String url) {
  var map = {"fl-native-fl": isNative, "arg": argument, "url": url};
  var result = json.encode(map);
  return result;
}

Map<String, PageBuilder> getPageBuilder() {
  Map<String, PageBuilder> pageBuilder = {};

  routeConfigs.forEach((key, value) {
    pageBuilder.addAll({
      key: (String pageName, Map<dynamic, dynamic> params, String _) =>
          Wrapper(child: value(pageName, params, _))
    });
  });
  return pageBuilder;
}

Map<String, Widget Function(BuildContext)> getRoutes() {
  final Map<String, Widget Function(BuildContext)> routes = {};
  routeConfigs.forEach((key, value) {
    routes.addAll({
      key: (context) => Wrapper(routeContext: context, child: value('', {}, ''))
    });
  });
  return routes;
}

class XTRouter {
  ///flutter_boost注册路由
  static registerPageBuilders() {
    FlutterBoost.singleton.registerPageBuilders(getPageBuilder());
  }

  ///push到新页面 如果是原生页面 请把isNativePage 设置为true
  static Future<T> pushToPage<T extends Object>({
    @required String routerName, //路由名称
    Map<String, dynamic> params, //路由参数
    @required BuildContext context, //上下文
    bool isNativePage = false, //是不是原生页面
  }) {
    tracePage(routerName, params);

    if (AppConfig.getInstance().isAppSubModule) {
      if (isNativePage == true) {
        routerName = makeRouter(isNativePage, params, routerName);
      }
      if (params != null) {
        return FlutterBoost.singleton
            .open(routerName, urlParams: Map.from(params))
            .then((res) {
          print("----- ----FlutterBoost.singleton-------- -----------");
          return res as T;
        });
      } else {
        return FlutterBoost.singleton
            .open(routerName, urlParams: params)
            .then((res) {
          return res as T;
        });
      }
    } else {
      return Navigator.of(context ?? Global.context)
          .pushNamed(routerName, arguments: params);
    }
  }

  ///present到新页面 如果是原生页面 请把isNativePage 设置为true
  static Future<T> presentToPage<T extends Object>({
    String routerName, //路由名称
    Map<String, dynamic> params, //路由参数
    @required BuildContext context,
    bool isNativePage = false, //是不是原生页面
  }) {
    tracePage(routerName, params);
    if (AppConfig.getInstance().isAppSubModule) {
      if (isNativePage == true) {
        routerName = makeRouter(isNativePage, params, routerName);
      }
      Map tp = params == null ? Map.from({"present": true}) : Map.from(params);
      tp["present"] = true;
      return FlutterBoost.singleton.open(routerName, urlParams: tp).then((res) {
        print("------- ---FlutterBoost.singleton-------- -------");
        return res as T;
      });
    } else {
      print(Global.context);
      return Navigator.pushNamed(context, 'editPhone');
    }
  }

  ///关闭页面
  static Future<T> closePage<T extends Object>(
      {String routerName, //路由名称
      Map<String, dynamic> params, //路由参数
      @required BuildContext context,
      Map<String, dynamic> result,
      Map<String, dynamic> exts}) {
    if (AppConfig.getInstance().isAppSubModule) {
      final BoostContainerSettings settings =
          BoostContainer.of(context).settings;
      return FlutterBoost.singleton
          .close(settings.uniqueId, result: result, exts: exts)
          .then((value) {
        return value as T;
      });
    } else {
      // Navigator.of(context ?? Global.context).pop(result);
      Completer<T> com = Completer();
      return com.future;
    }
  }
}
