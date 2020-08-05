import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/UIPages/UserInfo/EditNamePage.dart';
import 'package:xtflutter/UIPages/UserInfo/UserInfoPage.dart';

import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTNetWork/HttpConfig.dart';
import 'FlutterBoostDemo/simple_page_widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => UserInfoVM()),
    ],
    child: MyApp(),
  ));
}
// MyApp()
// runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
      'embeded': (String pageName, Map<dynamic, dynamic> params, String _) =>
          EmbeddedFirstRouteWidget(),
      'first': (String pageName, Map<dynamic, dynamic> params, String _) =>
          FirstRouteWidget(),
      'firstFirst': (String pageName, Map<dynamic, dynamic> params, String _) =>
          FirstFirstRouteWidget(),
      'second': (pageName, params, String _) => SecondRouteWidget(),
      'secondStateful':
          (String pageName, Map<dynamic, dynamic> params, String _) =>
              SecondStatefulRouteWidget(),
      'tab': (String pageName, Map<dynamic, dynamic> params, String _) =>
          TabRouteWidget(),
      'platformView':
          (String pageName, Map<dynamic, dynamic> params, String _) =>
              PlatformRouteWidget(),
      'flutterFragment':
          (String pageName, Map<dynamic, dynamic> params, String _) =>
              FragmentRouteWidget(params),
      'info': (String pageName, Map<dynamic, dynamic> params, String _) =>
          UserInfoPage(),
       'editPage': (String pageName, Map<dynamic, dynamic> params, String _) =>
          EditNamePage(),  

      ///可以在native层通过 getContainerParams 来传递参数
      'flutterPage': (String pageName, Map<dynamic, dynamic> params, String _) {
        print('flutterPage params:$params');

        return FlutterRouteWidget(params: params);
      },
    });
    FlutterBoost.singleton
        .addBoostNavigatorObserver(TestBoostNavigatorObserver());
    getDeviceInfo();
  }

  void getDeviceInfo() async {
    print("object-------getDeviceInfo");
    var jsModel = await XTMTDChannel.invokeMethod("getDevice");
    setState(() {
      print("-----3333333-------");
      // HttpConfig.getInstance().updateConfig(, dict, black, token, platform)
      print(jsModel["platform"]);
      print(jsModel["black"]);
      print(jsModel["device"]);
      print("-----3333333-------");
      HttpConfig.getInstance().updateConfig(
          jsModel["baseURL"],
          jsModel["device"],
          jsModel["black"],
          jsModel["token"],
          jsModel["platform"]);

      print(HttpConfig.getInstance().device);
      print(HttpConfig.getInstance().baseURL);
      print(HttpConfig.getInstance().black);
      print("-----3333113333-------");

      // var mo = UserModel.fromMap(new Map<String, dynamic>.from(jsModel));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.black,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.white,
          accentColor: Colors.green,
          primaryColorBrightness: Brightness.light,
        ),
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        home: Container(color: Colors.white));
  }

  void _onRoutePushed(
    String pageName,
    String uniqueId,
    Map<String, dynamic> params,
    Route<dynamic> route,
    Future<dynamic> _,
  ) {}
}

class TestBoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPush');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPop');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didRemove');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print('flutterboost#didReplace');
  }
}
