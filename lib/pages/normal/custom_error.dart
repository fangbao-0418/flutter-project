import 'package:flutter/material.dart';
import 'package:flutter_boost/container/boost_container.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';

class CustomErrorWidget extends StatelessWidget {
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId,
        result: <String, dynamic>{'result': 'data from second'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: xtBackBar(title: "系统提示", back: () => _xtback(context)),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 70),
            width: 225,
            height: 225,
            decoration: xtRoundDecoration(10.0,
                image: DecorationImage(
                  image: AssetImage("images/empty.png"),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: xtText("糟糕，页面不见了~", 14, mainA8GrayColor,
                alignment: TextAlign.center),
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
                shape: xtShapeRoundLineCorners(
                    radius: 8.0, lineColor: mainRedColor, lineWidth: 1.0),
                onPressed: () {
                  XTRouter.pushToPage(
                      routerName: "home", context: context, isNativePage: true);
                  // FlutterBoost.singleton.open(makeRouter(true, {}, "home"));
                },
                child: xtText("回到首页", 16, mainRedColor)),
          )
        ],
      ),
    );
  }
}
