import 'dart:async';

import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/FlutterBoostDemo/simple_page_widgets.dart';
import 'package:xtflutter/UIPages/UserInfo/EditNamePage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditPhonePage.dart';
import 'package:xtflutter/UIPages/UserInfo/UserInfoPage.dart';
import 'package:xtflutter/UIPages/Address/AddAddressPage.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/setting_page.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';

class XTRouter {
  ///配置整体路由
  static routerCongfig() {
    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
      'setting': (String pageName, Map<dynamic, dynamic> params, String _) =>
          SettingPage(),
      'info': (String pageName, Map<dynamic, dynamic> params, String _) =>
          UserInfoPage(),
      'editPage': (String pageName, Map<dynamic, dynamic> params, String _) =>
          EditNamePage(params: params, name: pageName),
      'addAddress': (String pageName, Map<dynamic, dynamic> params, String _) =>
          AddAddressPage(),
      'editPhone': (String pageName, Map<dynamic, dynamic> params, String _) =>
          EditPhonePage(),

      ///可以在native层通过 getContainerParams 来传递参数
      'flutterPage': (String pageName, Map<dynamic, dynamic> params, String _) {
        print('flutterPage params:$params');
        return FlutterRouteWidget(params: params);
      },
    });
  }

  ///push到新页面
  static Future<T> pushToPage<T extends Object>({
    String routerName, //路由名称
    Map<String, dynamic> params, //路由参数
    BuildContext context, //上下文
  }) {
    if (AppConfig.getInstance().isAppSubModule) {
      print("55666666");

      if (params != null) {
        return FlutterBoost.singleton
            .open(routerName, urlParams: Map.from(params))
            .then((res) {
          print("----- ----FlutterBoost.singleton-------- -----------");
          return res as T;
        });
      } else {
        return FlutterBoost.singleton.open(routerName).then((res) {
          return res as T;
        });
      }
    } else {
      return Navigator.pushNamed(context, routerName, arguments: params);
    }
  }

  ///present到新页面
  static Future<T> presentToPage<T extends Object>({
    String routerName, //路由名称
    Map<String, dynamic> params, //路由参数
    BuildContext context,
  }) {
    if (AppConfig.getInstance().isAppSubModule) {
      Map tp = params == null
          ? new Map.from({"present": true})
          : new Map.from(params);
      tp["present"] = true;
      return FlutterBoost.singleton.open(routerName, urlParams: tp).then((res) {
        print("------- ---FlutterBoost.singleton-------- -------");
        return res as T;
      });
    } else {
      return Navigator.pushNamed(context, routerName, arguments: params);
    }
  }

  ///关闭页面
  static Future<T> closePage<T extends Object>(
      {String routerName, //路由名称
      Map<String, dynamic> params, //路由参数
      BuildContext context,
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
      Navigator.of(context).pop(result);
      Completer<T> com = Completer();
      return com.future;
    }
  }
}
