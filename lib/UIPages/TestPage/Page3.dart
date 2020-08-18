import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/Utils/Loading.dart';

class TestPage3 extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<TestPage3> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation<double> color;
  AnimationController controller;

  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  @override
  initState() {
    super.initState();
    // Loading.show();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    //图片宽高从0变到300
    animation = new Tween(begin: 100.0, end: 200.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0, 1, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    )
      // ..addListener(() {
      //   setState(() {});
      // })
      ..addStatusListener((status) {
        // print(status);
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
        // setState(() {});
      });
    color = new Tween(begin: 0.0, end: 250.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0, 1, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
    //启动动画(正向执行)
    // controller.forward();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: xtBackBar(title: "page2", back: () => _xtback(context)),
        body: Column(children: [
          RaisedButton(
              onPressed: () {
                Loading.show(context: context);
              },
              child: Text('loading show')),
          RaisedButton(
              onPressed: () {
                Loading.hide();
              },
              child: Text('loading hide')),
          RaisedButton(
              onPressed: () {
                Loading.forceHide();
              },
              child: Text('force loading hide')),
          // Container(
          //     color: Color.fromRGBO(165, 175, color.value.toInt(), 1),
          //     width: 50,
          //     height: animation.value)
          AnimatedBuilder(
              animation: controller,
              builder: (c, child) => Container(
                  color: Color.fromRGBO(165, 175, color.value.toInt(), 1),
                  width: 50,
                  height: animation.value))
        ]));
  }
}
