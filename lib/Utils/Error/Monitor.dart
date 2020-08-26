import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boost/container/boost_container.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/Utils/Error/ReportError.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodConfig.dart';
import '../../XTConfig/AppConfig/XTColorConfig.dart';

// 错误监控
void monitor(runApp) {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('============= flutter error start =============');
    print(details);
    print('============= flutter error end =============');
    reportError(details);
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    Widget view(context) {
      void _xtback(BuildContext context) {
        final BoostContainerSettings settings =
            BoostContainer.of(context).settings;
        FlutterBoost.singleton.close(settings.uniqueId,
            result: <String, dynamic>{'result': 'data from second'});
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: xtBackBar(title: "返回主页", back: () => _xtback(context)),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 70),
                width: 225,
                height: 225,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/empty.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "糟糕，首页不见了~",
                  style: TextStyle(fontSize: 14, color: mainA8GrayColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment.center,
                child: RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.fromLTRB(58, 12, 58, 12),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          width: 1,
                          color: Color(0xFFE60113),
                          style: BorderStyle.solid)),
                  onPressed: () {
                    FlutterBoost.singleton.open(makeRouter(true, {}, "home"));
                  },
                  child: Text("回到首页",
                      style: TextStyle(color: Color(0xFFE60113), fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(body:
        FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapShot) {
      return view(context);
    }));
  };

  runZoned(() {
    runApp();
  }, onError: (e, stack) {
    print('============= zoned start =============');
    print(e);
    print(stack);
    print('============= zoned end =============');
  });
}
