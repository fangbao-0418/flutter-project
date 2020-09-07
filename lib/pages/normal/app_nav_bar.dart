import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';

///导航标题文字样式
TextStyle navStyle = xtstyle(16, mainBlackColor, fontWeight: FontWeight.w500);

/// 左返回 标题 右完成
AppBar xtbackAndRightBar(
    {VoidCallback back,
    String title,
    String rightTitle,
    VoidCallback rightFun}) {
  return AppBar(
    elevation: 0,
    leading: IconButton(
      color: mainBlackColor,
      icon: Icon(
        Icons.arrow_back,
        size: 22,
      ),
      onPressed: back,
    ),
    title: Text("fl" + title, style: navStyle),
    actions: <Widget>[
      FlatButton(
        textColor: mainBlackColor,
        splashColor: whiteColor,
        highlightColor: whiteColor,
        child: Text(rightTitle, style: navStyle),
        onPressed: rightFun,
      ),
    ],
  );
}

/// 左返回 标题 右完成
AppBar xtBackBar({
  VoidCallback back,
  String title,
}) {
  return AppBar(
      elevation: 0,
      leading: IconButton(
        color: mainBlackColor,
        icon: Icon(
          Icons.arrow_back,
          size: 22,
        ),
        onPressed: back,
      ),
      title: Text("fl" + title, style: navStyle));
}
