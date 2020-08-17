import 'dart:async';

import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/FlutterBoostDemo/simple_page_widgets.dart';
import 'package:xtflutter/UIPages/Address/AddressListPage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditNamePage.dart';
import 'package:xtflutter/UIPages/UserInfo/EditPhonePage.dart';
import 'package:xtflutter/UIPages/UserInfo/UserInfoPage.dart';
import 'package:xtflutter/UIPages/Address/AddAddressPage.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/setting_page.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/Widgets/Wrapper.dart';
import 'package:xtflutter/Utils/Global.dart';

import 'package:xtflutter/UIPages/TestPage/page1.dart';
import 'package:xtflutter/UIPages/TestPage/page2.dart';

Map<String, PageBuilder> routeConfigs = {
  'setting': (pageName, params, _) => SettingPage(),
  'info': (pageName, params, _) => UserInfoPage(),
  'editPage': (pageName, params, _) =>
      EditNamePage(params: params, name: pageName),
  'addAddress': (pageName, params, _) => AddAddressPage(),
  'editPhone': (pageName, params, _) => EditPhonePage(),
  'flutterPage': (pageName, params, _) => FlutterRouteWidget(params: params),
  'page1': (pageName, params, _) => TestPage1(),
  'page2': (pageName, params, _) => TestPage2()
};

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

Map<String, dynamic> getRoutes() {
  final Map<String, Widget Function(BuildContext)> routes = {};
  // print(EditPhonePage);
  routeConfigs.forEach((key, value) {
    routes.addAll({
      key: (context) => Wrapper(routeContext: context, child: value('', {}, ''))
    });
  });
  return routes;
}

class XTRouter {
  ///配置整体路由
  static routerCongfig() {
    FlutterBoost.singleton.registerPageBuilders(getPageBuilder());
    print('registerPageBuilders end');
  }

  ///push到新页面
  static Future<T> pushToPage<T extends Object>({
    @required String routerName, //路由名称
    Map<String, dynamic> params, //路由参数
    @required BuildContext context, //上下文
  }) {
    if (AppConfig.getInstance().isAppSubModule) {
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
      return Navigator.of(context ?? Global.context).pushNamed(routerName, arguments: params);
    }
  }

  ///present到新页面
  static Future<T> presentToPage<T extends Object>({
    String routerName, //路由名称
    Map<String, dynamic> params, //路由参数
    @required BuildContext context,
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
      Navigator.of(context ?? Global.context).pop(result);
      Completer<T> com = Completer();
      return com.future;
    }
  }
}
