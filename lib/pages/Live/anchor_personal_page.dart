import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xtflutter/Utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/r.dart';
import 'package:xtflutter/router/router.dart';

class AnchorPersonalPage extends StatefulWidget {
  static String routerName = "AnchorPersonalPage";

  @override
  _AnchorPersonalPageState createState() => _AnchorPersonalPageState();
}

class _AnchorPersonalPageState extends State<AnchorPersonalPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  double _appBarOpacity = 0.0; //appbar透明度
  bool _isAttention = false; //是否关注
  GlobalKey _appBarKey = GlobalKey();
  GlobalKey _tabKey = GlobalKey();
  bool _showStickTabView = false;
  List<int> _liveStates = List();
  int _currentTab = 1; //默认回放tab
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _scrollViewController.addListener(() {
      Size size = _appBarKey.currentContext.size;
      var opacity = _scrollViewController.offset / size.height;
      _appBarOpacity = opacity <= 1 ? opacity : 1;
      if (_appBarOpacity <= 1) {
        setState(() {});
      }
      RenderBox _tabKeyrenderObject = _tabKey.currentContext.findRenderObject();
      Offset _tabKeyOffset = _tabKeyrenderObject.localToGlobal(Offset.zero);
      if (_tabKeyOffset.dy - size.height <= 0 && !_showStickTabView) {
        setState(() {
          _showStickTabView = true;
        });
      } else if (_tabKeyOffset.dy - size.height > 0 && _showStickTabView) {
        setState(() {
          _showStickTabView = false;
        });
      }
    });

    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    _tabController.addListener(() {
      if (_currentTab != _tabController.index) {
        _currentTab = _tabController.index;
        setState(() {});
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
          opacity: _appBarOpacity,
          child: Container(
            key: _appBarKey,
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
                  child: _isAttention
                      ? _buildShapeText("已关注", 12, main66GrayColor,
                          main66GrayColor, EdgeInsets.fromLTRB(5, 0, 5, 1),
                          isSold: false)
                      : _buildShapeText("+ 关注", 12, xtColor_FFE60113,
                          xtColor_FFE60113, EdgeInsets.fromLTRB(5, 0, 5, 1),
                          isSold: false),
                  onTap: () {
                    setState(() {
                      _isAttention = !_isAttention;
                    });
                  },
                ),
                _buildIconButton(R.imagesLiveLiveAnchorTopWhiteShare, 22,
                    () {
                  Toast.showToast(msg: "点击了分享");
                })
              ],
            ),
          ),
        ),
//        _showStickTabView?_buildTabView(true):null,
        if (_showStickTabView)
          _buildTabView(true, null)
      ],
    );
  }

  ///页面滑动内容
  _buildContainer() {
    return CustomScrollView(
      controller: _scrollViewController,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: _buildContainerTopAppBar(),
        ),
        _buildListItemByType(),
      ],
    );
  }

  _buildListItemByType() {
    if (_currentTab == 1) {
      return SliverList(
          delegate: SliverChildBuilderDelegate(
                  (BuildContext ctx, int index) {
                return _buildReplayListView(index);
              },
              childCount: 10
          ));
    } else {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverStaggeredGrid.countBuilder(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            staggeredTileBuilder: (index) =>
//              StaggeredTile.count(2, index==0 ? 2 : 4),
            StaggeredTile.fit(2),
            itemBuilder: (context, index) => _buildShowListView(index),
            itemCount: 10),
      );
    }
  }

  ///页面滑动内容顶部
  _buildContainerTopAppBar() {
    return Stack(
      children: <Widget>[
        Container(
          height: 211,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(R.imagesLiveLiveAnchorTopBg),
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
                    _buildIconButton(R.imagesLiveLiveAnchorTopBack, 22, () {
                      XTRouter.closePage(context: context);
                    }),
                    _buildIconButton(R.imagesLiveLiveAnchorTopShare, 22,
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
                        child: _isAttention
                            ? xtText("已关注", 12, xtColor_FFE60146)
                            : Image.asset(
                                R.imagesLiveLiveAnchorTopCancelAttention),
                      ),
                      onTap: () {
                        setState(() {
                          _isAttention = !_isAttention;
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
      _liveStates.add(i);
      list.add(_buildLiveStateView(i));
    }
    list.add(_buildTabView(false, _tabKey));
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
    var liveState = _liveStates[state];
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
                    xtText("开播时间：2020.12.28 19:00", 12, main99GrayColor,
                        overflow: TextOverflow.ellipsis)
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

  _buildTabView(bool isStick, Key key) {
    return TabBar(
      key: key,
      labelPadding: EdgeInsets.zero,
      controller: _tabController,
      unselectedLabelColor: xtColor_B3FFFFFF,
      indicatorColor: Colors.transparent,
      tabs: <Widget>[
        _buildSingleTabview(isStick, "口碑秀", 0),
        _buildSingleTabview(isStick, "直播回放", 1),
      ],
    );
  }

  ///口碑秀和直播回放的tabview
  _buildSingleTabview(bool isStick, String name, int currentTab) {
    bool isChecked = _currentTab == currentTab;
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
          color: isStick ? whiteColor : null,
          border: isStick
              ? Border.symmetric(vertical: BorderSide(color: mainF5GrayColor))
              : null),
          alignment: Alignment.center,
          height: 45,
          child: xtText(
              name, 16, isChecked ? xtColor_FFE20260 : main66GrayColor,
              fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal),
        ),
        Visibility(
          visible: currentTab == 0,
          child: Container(
              alignment: Alignment(1, 0),
              height: 45,
              child: Container(
                width: 0.5,
                height: 20,
                color: xtColor_FFDDDDDD,
              )
          ),
        )
      ],
    );
  }

  ///页面滑动内容列表(直播回放)
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
                R.imagesLiveLiveIconPlay,
                width: 38,
                height: 38,
              )
            ],
          )
        ],
      ),
    );
  }

  ///页面滑动内容列表(口碑秀)
  _buildShowListView(int index) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: whiteColor,
      shape: xtShapeRound(10),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: AspectRatio(
                aspectRatio: index % 2 == 0 ? 1 : 1440 / 800,
                child: Image.network(index % 2 == 0
                    ? "https://assets.hzxituan.com/supplier/77943E5ED2DCA759.jpg"
                    : "http://yanxuan.nosdn.127.net/65091eebc48899298171c2eb6696fe27.jpg")),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              children: <Widget>[
                xtText(
                    "强烈推荐抖音爆款超级好吃111，入口会爆水珠", 14, mainBlackColor, maxLines: 2),
                SizedBox(height: 12,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    xtRoundAvatarImage(16, 50,
                        "https://assets.hzxituan.com/assets/2020_0104/live_header.png"),
                    SizedBox(width: 2,),
                    Expanded(
                        child: xtText("我是我是我是我是我是我是", 10, main66GrayColor,
                            overflow: TextOverflow.ellipsis)
                    ),
                    SizedBox(width: 18,),
                    Image.asset(
                      R.imagesLiveLiveAnchorFavoriteRed, width: 14,
                      height: 14,),
                    SizedBox(width: 2,),
                    xtText("62.43w", 12, main66GrayColor),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

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
