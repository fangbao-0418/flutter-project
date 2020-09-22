import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';

class AnchorPersonalPage extends StatefulWidget {
  static String routerName = "AnchorPersonalPage";

  @override
  _AnchorPersonalPageState createState() => _AnchorPersonalPageState();
}

class _AnchorPersonalPageState extends State<AnchorPersonalPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  double appBarOpacity = 0.0; //appbar透明度
  bool isAttention = false; //是否关注
  GlobalKey appBarKey = GlobalKey();
  GlobalKey tabKey = GlobalKey();
  bool showStickTabView = false;
  List<int> liveStates = List();
  bool isCurrentReplayTab = true; //当前是否是回放tab,默认true

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _scrollViewController.addListener(() {
      Size size = appBarKey.currentContext.size;
      var opacity = _scrollViewController.offset / size.height;
      appBarOpacity = opacity <= 1 ? opacity : 1;
      if (appBarOpacity <= 1) {
        setState(() {});
      }
      RenderBox tabKeyrenderObject = tabKey.currentContext.findRenderObject();
      Offset tabKeyOffset = tabKeyrenderObject.localToGlobal(Offset.zero);
      if (tabKeyOffset.dy - size.height <= 0 && !showStickTabView) {
        setState(() {
          showStickTabView = true;
        });
      } else if (tabKeyOffset.dy - size.height > 0 && showStickTabView) {
        setState(() {
          showStickTabView = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print("高度===${MediaQueryData.fromWindow(window).padding.top}");
    return Scaffold(
      backgroundColor: mainF5GrayColor,
      body: Stack(
        children: <Widget>[
          _buildContainer(),
          _buildTopBar(),
        ],
      ),
    );
  }

  ///顶部下滑后的显示的appbar
  _buildTopBar() {
    return Column(
      children: <Widget>[
        Opacity(
          opacity: appBarOpacity,
          child: Container(
            key: appBarKey,
            color: Theme.of(context).primaryColor,
            height: AppConfig.navH,
            padding: EdgeInsets.only(top: AppConfig.statusH),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 22,
                  ),
                  onPressed: () {
                    XTRouter.closePage(context: context);
                  },
                ),
                xtRoundAvatarImage(30, 100,
                    "https://assets.hzxituan.com/assets/2020_0104/live_header.png"),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.topLeft,
                    widthFactor: 0.55,
                    child: xtText(
                        "我是我说我是我是谁我是我说我是我是谁我是我说我是我是谁", 14, mainBlackColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                GestureDetector(
                  child: isAttention
                      ? _buildShapeText("已关注", 12, main66GrayColor,
                          main66GrayColor, EdgeInsets.fromLTRB(5, 0, 5, 1),
                          isSold: false)
                      : _buildShapeText("+ 关注", 12, xtColor_FFE60113,
                          xtColor_FFE60113, EdgeInsets.fromLTRB(5, 0, 5, 1),
                          isSold: false),
                  onTap: () {
                    setState(() {
                      isAttention = !isAttention;
                    });
                  },
                ),
                _buildIconButton("images/live_anchor_top_white_share.png", 22,
                    () {
                  Toast.showToast(msg: "点击了分享");
                })
              ],
            ),
          ),
        ),
//        showStickTabView?_buildTabView(true):null,
        if (showStickTabView)
          _buildTabView(true, null)
      ],
    );
  }

  ///页面滑动内容
  _buildContainer() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 10,
        controller: _scrollViewController,
        itemBuilder: (BuildContext ctx, int index) {
          if (index == 0) {
            return _buildContainerTopAppBar();
          } else {
            return _buildReplayListView(index);
          }
        });
  }

  ///页面滑动内容顶部
  _buildContainerTopAppBar() {
    return Stack(
      children: <Widget>[
        Container(
          height: 211,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/live_anchor_top_bg.png"),
                fit: BoxFit.fill),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: AppConfig.navH,
                padding: EdgeInsets.only(top: AppConfig.statusH),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildIconButton("images/live_anchor_top_back.png", 22, () {
                      XTRouter.closePage(context: context);
                    }),
                    _buildIconButton("images/live_anchor_top_share.png", 22,
                        () {
                      Toast.showToast(msg: "点击了分享");
                    })
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    xtRoundAvatarImage(36, 100,
                        "https://assets.hzxituan.com/assets/2020_0104/live_header.png"),
                    SizedBox(
                      height: 10,
                    ),
                    xtText("我是我说我是我是谁", 16, whiteColor, maxLines: 1),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        xtText("TA的关注 19280", 14, whiteColor),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: 1.5,
                          height: 14,
                          color: mainA8GrayColor,
                        ),
                        xtText("粉丝 19280", 14, whiteColor),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: 1.5,
                          height: 14,
                          color: mainA8GrayColor,
                        ),
                        xtText("获赞 19280", 14, whiteColor),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                            color: whiteColor, shape: xtShapeRound(50)),
                        width: 62,
                        height: 24,
                        child: isAttention
                            ? xtText("已关注", 12, xtColor_FFE60146)
                            : Image.asset(
                                "images/live_anchor_top_cancel_attention.png"),
                      ),
                      onTap: () {
                        setState(() {
                          isAttention = !isAttention;
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        _buildContainerTopAppBarBelow(),
      ],
    );
  }

  ///页面appBar下面的内容,包含直播状态和tabview
  _buildContainerTopAppBarBelow() {
    var list = List<Widget>();
    for (int i = 0; i < 3; i++) {
      liveStates.add(i);
      list.add(_buildLiveStateView(i));
    }
    list.add(_buildTabView(false, tabKey));
    return Container(
      decoration:
          ShapeDecoration(color: mainF5GrayColor, shape: xtShapeRound(12)),
      margin: EdgeInsets.only(top: 191),
      child: Column(
        children: list,
      ),
    );
  }

  ///回放,预告,直播状态view
  _buildLiveStateView(int state) {
    var liveState = liveStates[state];
    bool isLiving = liveState == 0;
    bool isNotice = liveState == 1;
    bool noNotice = liveState == 2;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
      width: double.infinity,
      decoration: ShapeDecoration(color: whiteColor, shape: xtShapeRound(10)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                xtText("喜团官方直播-年货节送红包啦年货节送红包啦", 16, mainBlackColor,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildShapeText(
                        isLiving ? "直播中" : "预告",
                        12,
                        whiteColor,
                        isLiving ? mainRedColor : xtColor_FF29D69D,
                        EdgeInsets.fromLTRB(10, 0, 10, 1),
                        margin: EdgeInsets.only(right: 8)),
                    xtText("开播时间：2020.12.28 19:00", 12, main99GrayColor)
                  ],
                )
              ],
            ),
          ),
          _buildShapeText(
              isLiving ? "前往观看" : noNotice ? "开播提醒" : "取消提醒",
              12,
              isLiving
                  ? mainRedColor
                  : noNotice ? xtColor_FF29D69D : main66GrayColor,
              isLiving
                  ? mainRedColor
                  : noNotice ? xtColor_FF29D69D : main66GrayColor,
              EdgeInsets.fromLTRB(16, 4, 16, 5),
              isSold: false),
        ],
      ),
    );
  }

  ///口碑秀和直播回放的tabview
  _buildTabView(bool isStick, Key key) {
    return Container(
      decoration: BoxDecoration(
          color: isStick ? whiteColor : null,
          border: isStick
              ? Border.symmetric(vertical: BorderSide(color: mainF5GrayColor))
              : null),
      child: Row(
        key: key,
        children: <Widget>[
          _buildSingleTabview("口碑秀", false),
          Container(
            width: 0.5,
            height: 20,
            color: xtColor_FFDDDDDD,
          ),
          _buildSingleTabview("直播回放", true),
        ],
      ),
    );
  }

  _buildSingleTabview(String name, bool isReplayTab) {
    bool isChecked = isCurrentReplayTab == isReplayTab;
    return Expanded(
      child: GestureDetector(
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          height: 45,
          child: xtText(
              name, 16, isChecked ? xtColor_FFE20260 : main66GrayColor,
              fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal),
        ),
        onTap: () {
          if (!isChecked)
            setState(() {
              isCurrentReplayTab = !isCurrentReplayTab;
            });
        },
      ),
    );
  }

  ///页面滑动内容列表(直播回放或者口碑秀)
  _buildReplayListView(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, left: 12, right: 12),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      width: double.infinity,
      decoration: ShapeDecoration(color: whiteColor, shape: xtShapeRound(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  xtText("情人节专场直播$index", 16, mainBlackColor,
                      fontWeight: FontWeight.w600),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      _buildShapeText("回放", 12, whiteColor, xtColor_4D88FF,
                          EdgeInsets.fromLTRB(10, 0, 10, 1),
                          margin: EdgeInsets.only(right: 8)),
                      xtText("人气 2887 | 12商品", 12, main99GrayColor)
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
              xtText("02.14", 12, main99GrayColor)
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              xtRoundAvatarImage(
                200,
                6,
                "https://sh-tximg.hzxituan.com/tximg/app-upload/test/image/30393791-0454-44df-8ac3-47d3efaf672b.png",
              ),
              Image.asset(
                "images/live_icon_play.png",
                width: 38,
                height: 38,
              )
            ],
          )
        ],
      ),
    );
  }

  _buildShowListView(int index) {}

  _buildIconButton(String name, double size, VoidCallback callback) {
    return IconButton(
        icon: Image.asset(name), iconSize: size, onPressed: callback);
  }

  _buildShapeText(String text, double fontSize, Color textColor,
      Color shapeColor, EdgeInsets padding,
      {EdgeInsets margin = EdgeInsets.zero, bool isSold = true}) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: isSold
          ? ShapeDecoration(color: shapeColor, shape: xtShapeRound(50))
          : BoxDecoration(
              border: Border.all(
                color: shapeColor,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
      child: xtText(text, fontSize, textColor),
    );
  }
}
