import 'package:flutter/material.dart';
import 'package:flutter_boost/container/boost_container.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'package:xtflutter/config/app_config/color_config.dart';
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
                "糟糕，页面不见了~",
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
                  XTRouter.pushToPage(
                      routerName: "home", context: context, isNativePage: true);
                  // FlutterBoost.singleton.open(makeRouter(true, {}, "home"));
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
}
