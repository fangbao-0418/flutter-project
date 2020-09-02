import 'dart:convert';

import 'package:flutter/material.dart';

///原生跳转参数配置
String makeRouter(bool isNative, Map argument, String url) {
  var map = {"native": isNative, "arg": argument, "url": url};
  var result = json.encode(map);
  return result;
}

///设置文本Style
TextStyle xtstyle(double size, String colorHexString,
    {FontWeight fweight = FontWeight.normal, Color bgcolor = Colors.white}) {
  return TextStyle(
      color: HexColor(colorHexString),
      fontSize: size,
      fontWeight: fweight,
      backgroundColor: bgcolor);
}

///颜色拓展
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
