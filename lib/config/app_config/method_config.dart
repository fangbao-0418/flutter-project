import 'package:flutter/material.dart';

///设置文本Style
TextStyle xtstyle(double size, String colorHexString,
    {FontWeight fweight = FontWeight.normal, Color bgcolor = Colors.white}) {
  return TextStyle(
      color: HexColor(colorHexString),
      fontSize: size,
      fontWeight: fweight,
      backgroundColor: bgcolor);
}

///设置圆角
RoundedRectangleBorder xtRoundCorners(double radius) {
  ///设置圆角
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

///设置空心圆角线  圆弧 线宽 线色
RoundedRectangleBorder xtRoundLineCorners(
    {double radius, double lineWidth, Color lineColor}) {
  ///设置空心圆角线  圆弧 线宽 线色
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(
          width: lineWidth, color: lineColor, style: BorderStyle.solid));
}

///圆角网络图片 avatarWH 图片宽高 圆角 地址
Container xtRoundAvatarImage(double avatarWH, double radius, imageUrl) {
  ///圆角网络图片 宽高 圆角 地址
  return Container(
    width: avatarWH,
    height: avatarWH,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
        )),
  );
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
