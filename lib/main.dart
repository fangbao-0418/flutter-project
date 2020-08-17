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
import 'package:xtflutter/Utils/Global.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => UserInfoVM()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _batteryLevel = 'Unknown battery level.';
  static const platform = const MethodChannel('flutter_native_channel');
  @override
  void initState() {
    super.initState();
    // Global.context = context;
    // print('xxxxxxxxx');
    // _getBatteryLevel();
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

    print('app init state');
    ///路由配置 -- flutter_boost
    XTRouter.routerCongfig();

    // FlutterBoost.singleton.addBoostNavigatorObserver(TestBoostNavigatorObserver());
    // getDeviceInfo();
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    print('_getBatteryLevel');
    print(platform);
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      print('getBatteryLevel');
      print(result);
      // batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      // batteryLevel = "Failed to get battery level: '${e.message}'.";
      print('error');
    }

    // setState(() {
    //   _batteryLevel = batteryLevel;
    // });
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
    print('my app build');
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
        home: Home());
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
    // TODO: implement dispose
    super.dispose();
    print('app dispose');
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('home build');
    Global.context = context;
    return Container(
      // height: 100,
      color: Colors.green,
      child: Wrapper(
        child: SettingPage(),
      ),
    );
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
