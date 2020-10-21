import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/promotion_model.dart';
import 'package:xtflutter/pages/promotion/promotionItem/nav_bar_titles.dart';
import 'package:xtflutter/utils/event_bus.dart';

class FlowBarTitles extends StatefulWidget {
  static const busName = "FlowBarTitlesShow";
  FlowBarTitles(this.auchorNames, this.auchorids, this.config,
      {this.barTitleSelectColor = mainRedColor,
      this.barTitleNormalColor = mainBlackColor,
      this.barbackColor = mainF5GrayColor,
      this.onTap});
  final List<String> auchorNames;
  final List<int> auchorids;
  final Color barbackColor;
  final Color barTitleNormalColor;
  final Color barTitleSelectColor;
  final ValueChanged<int> onTap;
  final Config config;
  @override
  _FlowBarTitlesState createState() => _FlowBarTitlesState();
}

class _FlowBarTitlesState extends State<FlowBarTitles> {
  bool flowNavBarShow = false;

  @override
  void initState() {
    super.initState();
    bus.on(FlowBarTitles.busName, (arg) {
      print("-------arg ------------" + arg.toString());
      bool show = (arg as List<bool>).first;
      if (flowNavBarShow != show) {
        flowNavBarShow = show;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainSize: false,
      maintainState: true, // 隐藏后是否维持组件状态
      maintainAnimation: true, // 隐藏后是否维持子组件中的动画
      visible: flowNavBarShow,
      child: TitlesNavBar(widget.auchorNames, widget.auchorids, "flow",
          barbackColor: widget.config.bgColor != null
              ? HexColor(widget.config.bgColor)
              : mainF5GrayColor,
          barTitleNormalColor: widget.config.fontColor != null
              ? HexColor(widget.config.fontColor)
              : mainBlackColor,
          barTitleSelectColor: widget.config.fontColorSelect != null
              ? HexColor(widget.config.fontColorSelect)
              : mainRedColor, onTap: (value) {
        print("-------------0000-------------");
        // bus.emit(TitlesNavBar.busName, [value]);
        _handleTap(value);
      }),
    );
  }

  void _handleTap(int index) {
    if (widget.onTap != null) {
      widget.onTap(index);
    }
  }
}
