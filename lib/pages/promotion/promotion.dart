import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';

class Promotion extends StatefulWidget {
  static const routerName = "promotion";

  Promotion({this.name, this.params});

  /// 路由名称
  final String name;

  /// 传过来的参数
  final Map<String, dynamic> params;

  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  @override
  void initState() {
    super.initState();
  }

  void xtback() {
    XTRouter.closePage(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "活动", back: () => XTRouter.closePage(context: context)),
      body: xtText("活动页呀" + widget.params["id"], 20, mainRedColor),
    );
  }
}
