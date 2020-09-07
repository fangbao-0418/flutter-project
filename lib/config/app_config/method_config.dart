import 'package:flutter/material.dart';

///设置文本Style
TextStyle xtstyle(double size, Color color,
    {FontWeight fontWeight = FontWeight.normal, Color bgcolor = Colors.white}) {
  return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
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

///通用Text
///txt 文字
///fontSize 字号
///colorString 字色
///fontWeight 字体粗细
///bgcolor 背景色
///alignment 对齐方式
Text xtText(String txt, double fontSize, Color color,
    {FontWeight fontWeight = FontWeight.normal,
    Color bgcolor = Colors.white,
    TextAlign alignment,
    int maxLines,
    bool softWrap}) {
  ///txt 文字 字号 字色 字体粗细 背景色  对齐方式
  return Text(
    txt,
    style: xtstyle(fontSize, color, fontWeight: fontWeight, bgcolor: bgcolor),
    textAlign: alignment,
    maxLines: maxLines,
    softWrap: softWrap,
  );
}

///Text 文字 样式 对其方式
Text xtTextWithStyle(String txt, TextStyle style, {TextAlign alignment}) {
  ///txt 文字 字号 字色 字体粗细 背景色  对齐方式
  return Text(txt, style: style, textAlign: alignment);
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
