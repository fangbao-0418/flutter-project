import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xtflutter/UIPages/TestPage/Page1.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/Utils/Error/Monitor.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/local/proxy.dart';
import 'package:xtflutter/XTRouter/RoutesMap.dart';
import 'package:xtflutter/UIPages/setting_page.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'package:flutter/services.dart';
import 'package:xtflutter/Utils/Task/Task.dart';
import 'package:xtflutter/Widgets/Wrapper.dart';

void main() {
  monitor(() {
    Task.init();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AppConfig().userVM),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // dynamic subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   print('netWork status change');
    //   print(result);
    // });

    ///路由配置 -- flutter_boost
    XTRouter.registerPageBuilders();

    ///客户端更新用户或者切换环境使用
    FlutterBoost.singleton.channel.addEventListener('updateFlutterHeader',
        (name, arguments) {
      //todo
      print("updateFlutterHeader --- start");
      Map configMode = new Map.from(arguments);
      AppConfig.updateConfig(configMode["baseURL"], configMode["device"],
          configMode["black"], configMode["token"], configMode["platform"]);
      print("updateFlutterHeader --- end");
      return;
    });

    // ///客户端用户退出或者更换用户
    FlutterBoost.singleton.channel.addEventListener('updateUserInfo',
        (name, arguments) {
      // UserInfoVM
      //todo
      print("updateUserInfo --- start");
      Map<String, dynamic> configMode = Map.from(arguments);
      AppConfig().userVM.updateUser(UserInfoModel.fromJson(configMode));
      print("updateUserInfo --- end");
      return;
    });

    FlutterBoost.singleton
        .addBoostNavigatorObserver(TestBoostNavigatorObserver());
    if (inApp) {
      getDeviceInfo();
      getUIInfo();
      getSoftInfo();
      getUserInfo();
    }
  }

  void getDeviceInfo() async {
    var jsModel =
        new Map.from(await XTMTDChannel.invokeMethod("getNetWorkInfo"));
    print("-----get platform info-------" + jsModel.toString());
    AppConfig.updateConfig(jsModel["baseURL"], jsModel["device"],
        jsModel["black"], jsModel["token"], jsModel["platform"]);
    print("-----get platform info-------");
  }

  void getUIInfo() async {
    /// baseURL 、device、black、token、platform
    var uiInfo = Map.from(await XTMTDChannel.invokeMethod("getUIInfo"));
    print("uiInfo" + uiInfo.toString());
    AppConfig.updateVersion(uiInfo["appVersion"]);
    AppConfig.updateStatusHeight(uiInfo["statusHeight"]);
    AppConfig.updateNavHeight(uiInfo["navHeight"]);
    AppConfig.updateBottomMargin(uiInfo["bottomMargin"]);
  }

  void getUserInfo() async {
    String userInfo = await XTMTDChannel.invokeMethod("userInfo");

    Map<String, dynamic> tp =
        Map.from(json.decode(userInfo) as Map<String, dynamic>);

    AppConfig().userVM.updateUser(UserInfoModel.fromJson(tp));
  }

  void getSoftInfo() async {
    var map = await XTMTDChannel.invokeMethod("softInfo");
    print("softInfo ------- " + map.toString());
    AppConfig.updateSoftInfo(
        map["av"], map["dv"], map["md"], map["gid"], map["os"], map["ov"]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale.fromSubtags(languageCode: 'zh')
        ],
        debugShowCheckedModeBanner: false,
        color: Colors.black,
        theme: ThemeData(
            primaryColor: Colors.white,
            primaryColorBrightness: Brightness.light,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        routes: getRoutes(),
        home: Wrapper(child: Home()));
  }

  void _onRoutePushed(
    String pageName,
    String uniqueId,
    Map<String, dynamic> params,
    Route<dynamic> route,
    Future<dynamic> _,
  ) {}
  @override
  void dispose() {
    super.dispose();
    print('app dispose');
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // return Container(child: SettingPage());
    // return GlobalOfficalName();
    // return TestPage1(); page1 editPhone userInfo
    // return Wrapper(child: routeConfigs['fl-user-info']('', {}, ''));
    // return Text('xxx');
    // return Wrapper(child: routeConfigs['fl-user-info']('', {}, ''));
    // return routeConfigs['fl-user-info']('', {}, '');
    return SettingPage();
  }
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
