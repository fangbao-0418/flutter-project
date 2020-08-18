import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
// import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'Widgets/Wrapper.dart';
import 'UIPages/setting_page.dart';
import 'package:xtflutter/UIPages/UserInfo/EditPhonePage.dart';
import 'package:xtflutter/UIPages/TestPage/Page3.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => UserInfoVM()),
    ],
    child: MyApp(),
  ));
  FlutterError.onError = (FlutterErrorDetails details) {
    // reportError(details.exception, details.stack);
    print('reportError');
    print(details);
  };
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

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

    ///路由配置 -- flutter_boost
    XTRouter.routerCongfig();

    FlutterBoost.singleton
        .addBoostNavigatorObserver(TestBoostNavigatorObserver());
    // getDeviceInfo();
  }

  void getDeviceInfo() async {
    /// baseURL 、device、black、token、platform
    // var jsModel =
    //     new Map.from(await XTMTDChannel.invokeMethod("getNetWorkInfo"));
    // setState(() {
    //   print("-----get platform info-------");
    //   AppConfig.updateConfig(jsModel["baseURL"], jsModel["device"],
    //       jsModel["black"], jsModel["token"], jsModel["platform"]);
    //   print("-----get platform info-------");
    // });
    // var uiInfo = new Map.from(await XTMTDChannel.invokeMethod("getUIInfo"));
    // print("uiInfo" + uiInfo.toString());
    // AppConfig.updateVersion(uiInfo["appVersion"]);
    // AppConfig.updateStatusHeight(uiInfo["statusHeight"]);
    // AppConfig.updateNavHeight(uiInfo["navHeight"]);
    // AppConfig.updateBottomMargin(uiInfo["bottomMargin"]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.black,
        theme: ThemeData(
          // primarySwatch: Colors.orange,
          primaryColor: Colors.white,
          // accentColor: Colors.green,
          primaryColorBrightness: Brightness.light,
        ),
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        routes: getRoutes(),
        home: Home()
        // home: Container(
        //   child: TestPage3(),
        //   // child: EditPhonePage(),
        // ),
        );
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
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Global.context = context;
    // return Container(child: SettingPage());
    return TestPage3();
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
