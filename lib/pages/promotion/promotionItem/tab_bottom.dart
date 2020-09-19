import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/utils/global.dart';

class XTTabbar extends StatelessWidget {
  XTTabbar(this.data);

  final ComponentVoList data;
  @override
  Widget build(BuildContext context) {
    Style temp = Style();
    Color bgColor = whiteColor;
    Color fontColor = mainBlackColor;
    if (data.config.fontColor != null && data.config.fontColor.length > 0) {
      fontColor = HexColor(data.config.fontColor);
    }
    if (data.config.bgColor != null && data.config.bgColor.length > 0) {
      bgColor = HexColor(data.config.bgColor);
    }

    if (data.config.styleType == 0) {
    } else {}
    temp.textStyle(fontColor);

    if (data.config.styleType == 1) {
      return titles(data);
    } else {
      return StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            style:
                data.config.styleType == 1 ? TabStyle.titled : TabStyle.fixed,
            curveSize: 0,
            elevation: 0,
            top: 0,
            color: fontColor,
            activeColor: fontColor,
            backgroundColor: bgColor,
            items: tabbarItems(data),
            initialActiveIndex: 0, //optional, default as 0
            onTap: (int i) {
              Datum item = data.data[i];
              print(item.url);
            },
          ));
    }
  }
}

List<TabItem> tabbarItems(ComponentVoList data) {
  List<TabItem> temp = [];
  for (var item in data.data) {
    temp.add(TabItem(icon: Image.network(item.img), title: item.title));
  }
  return temp;
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 27;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 27;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 12, color: color);
  }
}

Widget titles(ComponentVoList data) {
  List<Widget> titles = [];
  Color fontColor = data.config.fontColor == null
      ? mainBlackColor
      : HexColor(data.config.fontColor);
  for (var item in data.data) {
    print(item.title);
    GestureDetector tep = GestureDetector(
        onTap: () {
          print("item.url");
          print(item.url);
          print("item.url");
        },
        child: Container(
            height: 48,
            alignment: Alignment(0, 0),
            color: Colors.yellow,
            padding: EdgeInsets.only(
                left: data.data.length >= 5 ? 5 : 10,
                right: data.data.length >= 5 ? 5 : 10),
            child: xtText(item.title, 14, fontColor, bgcolor: Colors.brown)));

    titles.add(tep);
  }
  // titles.add(tt);
  return Container(
    padding: EdgeInsets.only(bottom: AppConfig.bottomH),
    child: Row(
      children: titles,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    ),
  );
}
