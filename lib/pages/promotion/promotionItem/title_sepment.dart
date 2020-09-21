import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';

class TitleNav extends StatelessWidget {
  TitleNav(
    this.top,
    this.bottom,
    this.title,
    this.bgColor, {
    this.roundRadius = true,
    this.titleColor = whiteColor,
    this.height = 44,
    this.fontSize = 24,
  });
  final double top;
  final double fontSize;
  final double height;
  final double bottom;
  final String title;
  final bool roundRadius;
  final Color titleColor;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: xtRoundDecoration(height * 0.5, bgcolor: bgColor),
      alignment: Alignment(0, 0),
      height: height,
      margin: EdgeInsets.only(left: 20, right: 20, top: top, bottom: bottom),
      child: xtText(title, fontSize, titleColor, alignment: TextAlign.center),
    );
  }
}
