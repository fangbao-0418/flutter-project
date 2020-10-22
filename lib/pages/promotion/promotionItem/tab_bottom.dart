import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'package:xtflutter/utils/appconfig.dart';

class XTTabbar extends StatefulWidget {
  XTTabbar(this.data);

  final ComponentVoList data;

  @override
  _XTTabbarState createState() => _XTTabbarState();
}

class _XTTabbarState extends State<XTTabbar> with TickerProviderStateMixin {
  List<Widget> list = [];

  TabController tabC;

  int selectIndex = 0;

  @override
  void initState() {
    super.initState();

    tabC = TabController(
        initialIndex: selectIndex,
        length: widget.data.data.length,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = whiteColor;
    Color fontColor = mainBlackColor;
    if (widget.data.config.fontColor != null &&
        widget.data.config.fontColor.length > 0) {
      fontColor = HexColor(widget.data.config.fontColor);
    }
    if (widget.data.config.bgColor != null &&
        widget.data.config.bgColor.length > 0) {
      bgColor = HexColor(widget.data.config.bgColor);
    }

    if (widget.data.config.styleType == 0) {
      return titles(widget.data, bgColor);
    } else {
      return imgAndtitles(widget.data, bgColor);
    }
  }
}

Widget titles(ComponentVoList data, Color bgcolor) {
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

  return Container(
    color: bgcolor,
    padding: EdgeInsets.only(bottom: AppConfig.bottomH),
    child: Row(
      children: titles,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    ),
  );
}

Widget imgAndtitles(ComponentVoList data, Color bgcolor) {
  List<Widget> titles = [];
  Color fontColor = data.config.fontColor == null
      ? mainBlackColor
      : HexColor(data.config.fontColor);
  for (var item in data.data) {
    // print(item.title);
    GestureDetector tep = GestureDetector(
        onTap: () {
          print("item.url");
          print(item.url);
          print("item.url");
        },
        child: Container(
            height: 60,
            alignment: Alignment(0, 0),
            color: Colors.yellow,
            padding: EdgeInsets.only(
                left: data.data.length >= 5 ? 5 : 10,
                right: data.data.length >= 5 ? 5 : 10),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Image.network(
                    item.img,
                    height: 27,
                    width: 27,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    child:
                        xtText(item.title, 12, fontColor, bgcolor: clearColor)),
              ],
            )));

    titles.add(tep);
  }
  // titles.add(tt);
  return Container(
    color: bgcolor,
    padding: EdgeInsets.only(bottom: AppConfig.bottomH),
    child: Row(
      children: titles,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    ),
  );
}
