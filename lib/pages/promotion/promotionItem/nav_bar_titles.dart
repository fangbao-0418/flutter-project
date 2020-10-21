import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/utils/event_bus.dart';

class TitlesNavBar extends StatefulWidget {
  static const busName = "TitlesNavBarUpdate";
  TitlesNavBar(this.auchorNames, this.auchorids, this.name,
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

  final String name;

  @override
  _TitlesNavBarState createState() => _TitlesNavBarState();
}

class _TitlesNavBarState extends State<TitlesNavBar>
    with TickerProviderStateMixin {
  final ItemScrollController itemScrollController = ItemScrollController();

  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  List<Widget> list = [];
  bool gridView = false;

  bool arrowDown = true;

  double spacing = 20;
  OverlayEntry _overlay;
  int selectIndex = 0;
  TabController tabC;
  @override
  void initState() {
    super.initState();

    print("widget.auchorNames.length" + widget.auchorNames.length.toString());
    tabC = TabController(
        initialIndex: selectIndex,
        length: widget.auchorNames.length,
        vsync: this);

    bus.on(TitlesNavBar.busName, (arg) {
      int index = (arg as List<int>).first;

      if (selectIndex != index) {
        // print(widget.name);
        selectIndex = (arg as List<int>).first;
        if (mounted) {
          setState(() {
            tabC.index = selectIndex;
          });
        }
      }
    });
  }

  /// index == -1的时候属于点击箭头 qi yu
  void showAlert() {
    setState(() {
      if (!arrowDown) {
        _overlay = _createSelectViewWithContext(context);
        Overlay.of(context).insert(_overlay);
      } else {
        if (_overlay != null) {
          _overlay.remove();
        }
      }
    });
  }

  Widget item(index) {
    return index == selectIndex
        ? FlatButton.icon(
            padding: EdgeInsets.only(left: 0, right: 0),
            disabledColor: widget.barbackColor,
            disabledTextColor: widget.barbackColor,
            onPressed: null,
            icon: Icon(
              Icons.location_on,
              color: widget.barTitleSelectColor,
            ),
            label: xtText(
              widget.auchorNames[index],
              14,
              widget.barTitleSelectColor,
            ))
        : Container(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            color: widget.barbackColor,
            child: xtText(
                widget.auchorNames[index], 14, widget.barTitleNormalColor));
  }

  List<Widget> items() {
    if (list.length > 0) {
      list = [];
    }
    for (var i = 0; i < widget.auchorNames.length; i++) {
      list.add(item(i));
    }
    return list;
  }

  List<Widget> arrowPage() {
    if (arrowDown) {
      return [tabBar(), arrow()];
    } else {
      return [categoryItem(), arrow()];
    }
  }

  Widget categoryItem() {
    return Expanded(
        flex: 1,
        child: Container(
            color: widget.barbackColor,
            margin: EdgeInsets.only(left: 10, right: 0),
            // padding:
            child: xtText("类目切换", 14, main66GrayColor,
                softWrap: true, maxLines: 1)));
  }

  Widget arrow() {
    return Container(
      color: widget.barbackColor,
      width: 40,
      height: 40,
      child: IconButton(
          icon: Icon(
              arrowDown ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
          onPressed: () {
            arrowDown = !arrowDown;
            showAlert();
          }),
    );
  }

  Widget tabBar() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0),
        color: widget.barbackColor,
        child: Container(
            height: 40,
            child: TabBar(
              indicatorWeight: 1,
              indicatorColor: widget.barbackColor,
              isScrollable: true,
              tabs: items(),
              controller: tabC,
              onTap: (index) {
                selectIndex = index;
                setState(() {
                  bus.emit(TitlesNavBar.busName, [index]);
                  _handleTap(selectIndex);
                });
              },
            )),
      ),
    );
  }

  void _handleTap(int index) {
    if (widget.onTap != null) {
      print("1234");
      widget.onTap(widget.auchorids[index]);
    }
  }

  Widget bottomView() {
    if (!arrowDown) {
      return Container(
        color: Color.fromRGBO(0, 0, 0, 0.2),
        child: Column(
          children: <Widget>[
            Container(
              width: window.physicalSize.width,
              color: mainF5GrayColor,
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Tags(
                alignment: WrapAlignment.start,
                symmetry: false,
                columns: 20,
                spacing: spacing,
                horizontalScroll: false,
                verticalDirection: VerticalDirection.down,
                textDirection: TextDirection.ltr,
                heightHorizontalScroll: 200,
                itemCount: widget.auchorNames.length,
                itemBuilder: (index) {
                  final item = widget.auchorNames[index];
                  return GestureDetector(
                    child: ItemTags(
                      key: Key(index.toString()),
                      active: selectIndex == index,
                      index: index,
                      title: item,
                      pressEnabled: true,
                      activeColor: mainF5GrayColor,
                      color: mainF5GrayColor,
                      textColor: mainBlackColor,
                      textActiveColor: mainRedColor,
                      elevation: 0,
                      border: Border.all(
                          color: clearColor, width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      combine: ItemTagsCombine.withTextAfter,
                      icon: selectIndex == index
                          ? ItemTagsIcon(
                              icon: Icons.location_on,
                            )
                          : null,
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                      onPressed: (i) {
                        selectIndex = index;
                        arrowDown = true;
                        _handleTap(index);
                        showAlert();
                        bus.emit(TitlesNavBar.busName, [index]);
                        tabC.index = selectIndex;
                      },
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                arrowDown = !arrowDown;
                showAlert();
              },
              child: Container(
                padding: EdgeInsets.only(left: 0, right: 0),
                color: Color.fromRGBO(0, 0, 0, 0.0),
                height: 2000,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.barbackColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: arrowPage(),
      ),
    );
  }

  @override
  void dispose() {
    // tabC.dispose();
    super.dispose();
  }

  OverlayEntry _createSelectViewWithContext(BuildContext context) {
    //屏幕宽高
    RenderBox renderBox = context.findRenderObject();
    var screenSize = renderBox.size;
    //触发事件的控件的位置和大小
    // renderBox = this.findRenderObject();
    // var parentSize = renderBox.size;
    var parentPosition = renderBox.localToGlobal(Offset.zero);
    //正式创建Overlay
    return OverlayEntry(
      builder: (context) => Positioned(
        top: parentPosition.dy + 40,
        left: 0,
        width: screenSize.width,
        // height: 300,
        child: bottomView(),
      ),
    );
  }
}
