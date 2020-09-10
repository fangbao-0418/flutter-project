import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';

/// TextField 后边的clearBtn
/// width 宽 和 高一样 屏蔽高度参数
/// bgColor 按钮的背景色 main99GrayColor
/// closeColor  关闭按钮颜色 whiteColor
/// 请加上下边两行
/// suffixIconConstraints:
/// BoxConstraints(minHeight: 15, minWidth: 15),

Container xtTextFieldClear(
    {double width = 10,
    Color bgColor = main99GrayColor,
    Color closeColor = whiteColor,
    Function onPressed}) {
  ///  宽和高一样, 按钮的背景色, 关闭按钮颜色
  return Container(
    width: width,
    height: width,
    decoration: xtRoundDecoration(width, bgcolor: bgColor),
    child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.close,
          size: 10,
          color: closeColor,
        ),
        onPressed: onPressed),
  );
}

///设置文本Style
/// size 字体大小
/// color 文字颜色
/// fontWeight 字体粗细
/// bgcolor 背景色
/// height 高度比例 https://flutter.github.io/assets-for-api-docs/assets/painting/text_height_comparison_diagram.png
TextStyle xtstyle(double size, Color color,
    {FontWeight fontWeight = FontWeight.normal,
    Color bgcolor = Colors.transparent,
    double height}) {
  return TextStyle(
      color: color,
      fontSize: size,
      height: height,
      fontWeight: fontWeight,
      backgroundColor: bgcolor);
}

/// 圆角的BoxDecoration
/// image 图片
/// bgcolor 背景色
/// borderColor 圆角颜色
/// borderWidth 圆角宽度
/// style  BorderStyle
BoxDecoration xtRoundDecoration(double radius,
    {DecorationImage image,
    Color bgcolor,
    Color borderColor = whiteColor,
    double borderWidth = 1.0,
    BorderStyle style = BorderStyle.solid}) {
  /// 圆角的BoxDecoration  图片 背景色  圆角颜色 圆角宽度  BorderStyle
  return BoxDecoration(
      //设置四周圆角 角度
      image: image,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: bgcolor,
      border: Border.all(color: borderColor, width: borderWidth, style: style));
}

///设置圆角  radius 圆角大小
RoundedRectangleBorder xtShapeRound(double radius) {
  ///设置圆角
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

///设置空心圆角线  圆弧 线宽 线色
RoundedRectangleBorder xtShapeRoundLineCorners(
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
    Color bgcolor = Colors.transparent,
    TextAlign alignment,
    int maxLines,
    bool softWrap,
    double height,
    TextOverflow overflow}) {
  ///txt 文字 字号 字色 字体粗细 背景色  对齐方式
  return Text(
    txt,
    style: xtstyle(fontSize, color,
        fontWeight: fontWeight, bgcolor: bgcolor, height: height),
    textAlign: alignment,
    maxLines: maxLines,
    softWrap: softWrap,
    overflow: overflow,
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
