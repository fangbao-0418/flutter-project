import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xtflutter/config/app_config/app_listener.dart';
import 'package:xtflutter/config/extension/string_extension.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/utils/error/monitor.dart';
import 'package:xtflutter/pages/setting/setting_page.dart';
import 'package:flutter/services.dart';
import 'package:xtflutter/utils/task/task.dart';
import 'package:xtflutter/pages/normal/wrapper.dart';

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

    ///路由配置 -- flutter_boost
    XTRouter.registerPageBuilders();

    AppListener.headerListener();
    AppListener.userinfoListener();
    AppListener.appInitInfo();
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
        title: appNameStr,
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
    return SettingPage();
  }
}
// flutter attach --debug-uri=http://127.0.0.1:64931/C5cDeMQXcEU=/
