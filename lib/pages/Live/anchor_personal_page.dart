import 'dart:typed_data';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/comment_show_model.dart';
import 'package:xtflutter/model/live_anchorPlan_model.dart';
import 'package:xtflutter/model/member_info_model.dart';
import 'package:xtflutter/model/video_replay_model.dart';
import 'package:xtflutter/net_work/live_request.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/refresh.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/pages/setting/setting_page.dart';
import 'package:xtflutter/pages/share/share_builder.dart';
import 'package:xtflutter/r.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/utils/number_utils.dart';

class AnchorPersonalPage extends StatefulWidget {
  static String routerName = "AnchorPersonalPage";

  /// 传过来的参数
  final Map<String, dynamic> params;

  AnchorPersonalPage({this.params});

  @override
  _AnchorPersonalPageState createState() => _AnchorPersonalPageState();
}

class _AnchorPersonalPageState extends State<AnchorPersonalPage>
    with SingleTickerProviderStateMixin {
  String _memberId;
  MemberInfoModel _memberInfoModel;
  List<LiveAnchorPlanModel> _liveAnchorPlanList = List();
  List<VideoReplayModel> _videoReplayList = List();
  List<CommentShowModel> _commentShowList = List();
  ScrollController _scrollViewController;
  bool _isAttention = false; //是否关注
  GlobalKey<_AnchorAppBarState> _appBarKey = GlobalKey();
  GlobalKey _tabKey = GlobalKey();
  GlobalKey _stickTabKey = GlobalKey();
  GlobalKey _listItemKey = GlobalKey();
  bool _showStickTabView = false;
  int _currentTab; //默认0为口碑秀tab,1为回放tab,
  TabController _tabController;
  int _commentCurrentPage = 1;
  bool haveRequestComment = false;
  int _repalyCurrentPage = 1;
  bool haveRequestReplay = false;
  bool _canPublish = false;

  /// 刷新器
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
//    _memberId = widget.params["memberId"] ?? "7839523";
    _memberId = widget.params["memberId"] ?? "7839695";
    _currentTab = (widget.params["type"] ?? 0) == 1 ? 0 : 1; //不传值则默认回放
    getMemberInfo(false);

    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _scrollViewController.addListener(() {
      Size size = _appBarKey.currentContext.size;
      var opacity = _scrollViewController.offset / size.height;
      double _appBarOpacity = opacity >= 1 ? 1 : opacity <= 0 ? 0 : opacity;
      if (_appBarOpacity <= 1) {
        _AnchorAppBarState currentState = _appBarKey.currentState;
        currentState.setAppBarOpacity(_appBarOpacity);
      }
      //主播端才有回放
      if (_memberInfoModel != null && _memberInfoModel.isAnchor) {
        RenderBox _tabKeyrenderObject =
            _tabKey.currentContext.findRenderObject();
        if (_tabKeyrenderObject == null) return;
        _AnchorTabBarState _anchorTabBarState = _stickTabKey.currentState;
        Offset _tabKeyOffset = _tabKeyrenderObject.localToGlobal(Offset.zero);
        if (_tabKeyOffset.dy - size.height <= 0 && !_showStickTabView) {
          _showStickTabView = true;
          _anchorTabBarState?.showStickView(_showStickTabView);
        } else if (_tabKeyOffset.dy - size.height > 0 && _showStickTabView) {
          _showStickTabView = false;
          _anchorTabBarState?.showStickView(_showStickTabView);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  ///请求个人信息
  void getMemberInfo(bool isRefresh) {
    if (!isRefresh) Loading.show(context: context);
    XTUserInfoRequest.getMemberInfo(_memberId).then((value) {
      _memberInfoModel = value;
      _isAttention = _memberInfoModel.isFocus;
      _appBarKey.currentState.setAttention(_isAttention);
      _controller.finishRefresh();
      canPublish();
      getAnchorPlanList(_memberInfoModel.anchor.id.toString());
      getInfoByTab();
    }).whenComplete(() {
      if (!isRefresh) Loading.hide();
    });
  }

  ///依据当前页面请求页面列表信息
  getInfoByTab() {
    if (_currentTab == 1) {
      if (!haveRequestReplay) {
        getVideoReplayList(
            _memberInfoModel.anchor.id.toString(), _repalyCurrentPage);
      } else {
        _AnchorListItemState _anchorListItemState = _listItemKey.currentState;
        _anchorListItemState.setVideoReplayList(
            _videoReplayList, _memberInfoModel, _currentTab);
      }
      haveRequestReplay = true;
    } else {
      if (!haveRequestComment) {
        getCommentShowList(_commentCurrentPage);
      } else {
        _AnchorListItemState _anchorListItemState = _listItemKey.currentState;
        _anchorListItemState.setCommentShowList(
            _commentShowList, _memberInfoModel, _currentTab);
      }
      haveRequestComment = true;
    }
  }

  ///请求主播直播计划列表
  void getAnchorPlanList(String anchorId) {
    LiveRequest.getAnchorPlanList(anchorId).then((value) {
      _liveAnchorPlanList = value;
      setState(() {});
    });
  }

  ///获取主播个人页回放列表
  void getVideoReplayList(String anchorId, int currentPage) {
    LiveRequest.getVideoReplayList(anchorId, currentPage).then((value) {
      if (_repalyCurrentPage == 1) {
        _videoReplayList = value;
        _controller.finishLoad(noMore: value.length == 0);
      } else {
        _videoReplayList.addAll(value);
        _controller.finishLoad(noMore: value.length < 10);
      }
      _AnchorListItemState _anchorListItemState = _listItemKey.currentState;
      _anchorListItemState.setVideoReplayList(
          _videoReplayList, _memberInfoModel, _currentTab);
    });
  }

  ///获取主播个人页口碑秀列表
  void getCommentShowList(int currentPage) {
    LiveRequest.getCommentShowList(_memberId, currentPage).then((value) {
      if (_commentCurrentPage == 1) {
        _commentShowList = value;
        _controller.finishLoad(noMore: value.length == 0);
      } else {
        _commentShowList.addAll(value);
        _controller.finishLoad(noMore: value.length < 10);
      }
      _AnchorListItemState _anchorListItemState = _listItemKey.currentState;
      _anchorListItemState.setCommentShowList(
          _commentShowList, _memberInfoModel, _currentTab);
    });
  }

  ///点赞或者取消点赞
  void likeOrCancelLike(int materialId) {
    LiveRequest.likeOrCancelLike(materialId);
  }

  ///关注或者取消关注
  void attentionRequest() {
    if (_isAttention) {
      //已关注弹框二次确认
      showCupertinoDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              content: xtText("确认不再关注?", 14, mainBlackColor),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: xtText("取消", 14, mainBlackColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: xtText("确定", 14, mainBlackColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                    LiveRequest.cancelAttentionRequest(int.parse(_memberId), 1)
                        .then((value) {
                      if (value) {
                        _isAttention = !_isAttention;
                        _appBarKey.currentState.setAttention(_isAttention);
                        setState(() {});
                        Toast.showToast(msg: "取消关注主播成功~");
                      }
                    });
                  },
                ),
              ],
            );
          });
    } else {
      LiveRequest.attentionRequest(int.parse(_memberId), 1, 1, 0).then((value) {
        if (value) {
          _isAttention = !_isAttention;
          _appBarKey.currentState.setAttention(_isAttention);
          setState(() {});
          Toast.showToast(msg: "关注主播成功~");
        }
      });
    }
  }

  ///取消或者订阅提醒
  void checkOnOffNotice(LiveAnchorPlanModel planModel) {
    var openNotice = planModel.liveInfo.openNotice;
    LiveRequest.checkOnOffNotice(
            openNotice, planModel.liveInfo.id, planModel.anchor.id)
        .then((value) {
      Toast.showToast(msg: value);
      planModel.liveInfo.openNotice = !openNotice;
      setState(() {});
    });
  }

  ///是否可以发布
  void canPublish() {
    LiveRequest.canPublish().then((value) {
      if (value) {
        _canPublish = true;
        _AnchorListItemState _anchorListItemState = _listItemKey.currentState;
        _anchorListItemState.canPublish = _canPublish;
      }
    });
  }

  ///去发布页面
  void goCommentPublish() {
    XTRouter.pushToPage(
            routerName:
                "goPublish?logtype1=profilepublish&memberId1=$_memberId&source1=profile",
//            "https://testing.hzxituan.com/index.html?v=202009281026/#/goods/comment/release?logtype=profilepublish&memberId=$_memberId&source=profile",
            params: {"requestCode": 100},
            context: context,
            isNativePage: true)
        .then((value) {
      refreshPage();
    });
  }

  ///分享
  void doShareAction() {
    String page = "module_live/pages/personal/index";
    String scene =
        "id=$_memberId&mid=${AppConfig.user.mid}&type=${_currentTab == 0 ? "1" : "0"}";
    String title;
    if (_currentTab == 0) {
      title = "@${_memberInfoModel?.nickName}的喜团主页，快来关注吧！";
      shareToMiNi(context, page, scene, title: title);
    } else {
      title = "给你推荐了一个超棒的喜团主播-${_memberInfoModel?.nickName}";
      showBottomShareDialog(context, page, scene,
          title: title,
          desc: "主播昵称: ${_memberInfoModel?.nickName}",
          anchorId: _memberId);
    }
  }

  ///刷新
  void refreshPage() {
    haveRequestReplay = false;
    haveRequestComment = false;
    _repalyCurrentPage = 1;
    _commentCurrentPage = 1;
    _controller.resetLoadState();
    getMemberInfo(true);
  }

  ///加载更多
  void loadMore() {
    if (_currentTab == 0) {
      _commentCurrentPage++;
      getCommentShowList(_commentCurrentPage);
    } else {
      _repalyCurrentPage++;
      getVideoReplayList(
          _memberInfoModel.anchor.id.toString(), _repalyCurrentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
//    print("高度===${MediaQueryData.fromWindow(window).padding.top}");
    return Scaffold(
      backgroundColor: mainF5GrayColor,
      body: Stack(children: <Widget>[
        _buildContainer(),
        _buildTopBarAndStickTab(),
      ]),
      floatingActionButton: Visibility(
        visible: _canPublish && (_memberInfoModel?.isSelf ?? false),
        child: FloatingActionButton(
          backgroundColor: mainRedColor,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () {
            goCommentPublish();
          },
        ),
      ),
    );
  }

  ///顶部下滑后的显示的appbar
  _buildTopBarAndStickTab() {
    return Column(
      children: <Widget>[
        AnchorAppBar(
            _memberInfoModel, _appBarKey, attentionRequest, doShareAction),
        _buildTabView(true, _stickTabKey)
      ],
    );
  }

  ///页面滑动内容
  _buildContainer() {
    return XTRefresh(
      controller: _controller,
      onRefresh: refreshPage,
      onLoad: loadMore,
      child: CustomScrollView(
        controller: _scrollViewController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildContainerTopAppBar(),
          ),
          AnchorListItem(_listItemKey, _memberInfoModel, _currentTab,
              goCommentPublish, refreshPage, likeOrCancelLike),
        ],
      ),
    );
  }

  ///页面滑动内容顶部
  _buildContainerTopAppBar() {
    return Stack(
      children: <Widget>[
        Container(
          height: 207,
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
                    _buildIconButton(R.imagesLiveLiveAnchorTopShare, 22, () {
                      doShareAction();
                    })
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 55,
                    ),
                    _buildHeadView(36, _memberInfoModel?.headImage),
                    SizedBox(
                      height: 10,
                    ),
                    xtText(_memberInfoModel?.nickName ?? "", 16, whiteColor,
                        maxLines: 1),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        xtText("TA的关注 ${_memberInfoModel?.focusTotal ?? 0}", 14,
                            whiteColor),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: 1.5,
                          height: 14,
                          color: mainA8GrayColor,
                        ),
                        xtText("粉丝 ${_memberInfoModel?.fansTotal ?? 0}", 14,
                            whiteColor),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: 1.5,
                          height: 14,
                          color: mainA8GrayColor,
                        ),
                        xtText("获赞 ${_memberInfoModel?.likeTotal ?? 0}", 14,
                            whiteColor),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    _buildContainerTopBarIsSelf()
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

  _buildContainerTopBarIsSelf() {
    if (_memberInfoModel == null) {
      return _buildEmptyView();
    } else if (_memberInfoModel.isSelf) {
      return GestureDetector(
        child: Image.asset(
          R.imagesLiveAnchorGoSetting,
          width: 99,
          height: 24,
        ),
        onTap: () {
          XTRouter.pushToPage(
                  routerName: SettingPage.routerName, context: context)
              .then((value) {
            refreshPage();
          });
        },
      );
    } else {
      return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration:
              ShapeDecoration(color: whiteColor, shape: xtShapeRound(50)),
          width: 62,
          height: 24,
          child: _isAttention
              ? xtText("已关注", 12, xtColor_FFE60146)
              : Image.asset(R.imagesLiveLiveAnchorTopCancelAttention),
        ),
        onTap: () {
          setState(() {
            attentionRequest();
          });
        },
      );
    }
  }

  ///页面appBar下面的内容,包含直播状态和tabview
  _buildContainerTopAppBarBelow() {
    var list = List<Widget>();
    if (_memberInfoModel == null) return _buildEmptyView();
    if (_memberInfoModel.isAnchor) {
      if (_liveAnchorPlanList.length > 0) {
        _liveAnchorPlanList.forEach((element) {
          list.add(_buildLiveStateView(element));
        });
      }
      list.add(_buildTabView(false, _tabKey));
    }
    if (list.isEmpty)
      list.add(Container(
        height: (12),
      ));
    return Container(
      decoration: ShapeDecoration(
          color: mainF5GrayColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)))),
      margin: EdgeInsets.only(top: 196),
      child: Column(
        children: list,
      ),
    );
  }

  ///回放,预告,直播状态view
  _buildLiveStateView(LiveAnchorPlanModel planModel) {
    var liveInfo = planModel?.liveInfo;
    var liveState = liveInfo?.status; //3:直播中  1:预告
    bool isLiving = liveState == 3;
    bool openNotice = liveInfo.openNotice;
    return GestureDetector(
      child: Container(
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
                  xtText(liveInfo?.title ?? "", 16, mainBlackColor,
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
                      xtText(
                          isLiving
                              ? "人气 ${planModel?.statistics?.popularity ?? "0"}"
                              : "开播时间: ${DateUtil.formatDateMs(liveInfo?.startTime, format: "yyyy.MM.dd HH:mm")}",
                          12,
                          main99GrayColor,
                          overflow: TextOverflow.ellipsis)
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              child: _buildShapeText(
                  isLiving ? "前往观看" : openNotice ? "取消提醒" : "开播提醒",
                  12,
                  isLiving
                      ? mainRedColor
                      : openNotice ? main66GrayColor : xtColor_FF29D69D,
                  isLiving
                      ? mainRedColor
                      : openNotice ? main66GrayColor : xtColor_FF29D69D,
                  EdgeInsets.fromLTRB(16, 4, 16, 5),
                  isSold: false),
              onTap: () {
                if (isLiving) {
                  XTRouter.pushToPage(
                      routerName:
                          "live-room-audience?id=${planModel.liveInfo.id}",
                      context: context,
                      isNativePage: true);
                } else {
                  checkOnOffNotice(planModel);
                }
              },
            ),
          ],
        ),
      ),
      onTap: () {
        if (isLiving) {
          XTRouter.pushToPage(
              routerName: "live-room-audience?id=${planModel.liveInfo.id}",
              context: context,
              isNativePage: true);
        } else {
          XTRouter.pushToPage(
              routerName: "live_end?id=${planModel.liveInfo.id}",
              context: context,
              isNativePage: true);
        }
      },
    );
  }

  _buildTabView(bool isStick, Key key) {
    if (_tabController == null) {
      _tabController =
          TabController(initialIndex: _currentTab, length: 2, vsync: this);
      _tabController.addListener(() {
        if (_currentTab != _tabController.index) {
          _currentTab = _tabController.index;
          getInfoByTab();
          _AnchorTabBarState tabBarState = _tabKey.currentState;
          _AnchorTabBarState _sticktabBarState = _stickTabKey.currentState;
          tabBarState?.setCurrentTab(_currentTab);
          _sticktabBarState?.setCurrentTab(_currentTab);
        }
      });
    }
    return AnchorTabBar(key, _tabController, isStick, _currentTab);
  }
}

///顶部透明度变化的appBar widget
class AnchorAppBar extends StatefulWidget {
  final MemberInfoModel _memberInfoModel;
  final Function clickAttention;
  final Function clickShare;

  AnchorAppBar(this._memberInfoModel, Key appbarKey, this.clickAttention,
      this.clickShare)
      : super(key: appbarKey);

  @override
  _AnchorAppBarState createState() => _AnchorAppBarState();
}

class _AnchorAppBarState extends State<AnchorAppBar> {
  bool _isAttention = false; //是否关注
  double _appBarOpacity = 0.0; //appbar透明度

  void setAttention(bool value) {
    _isAttention = value;
    setState(() {});
  }

  void setAppBarOpacity(double value) {
    _appBarOpacity = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _appBarOpacity,
      child: Container(
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
            _buildHeadView(30, widget._memberInfoModel?.headImage),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: widget._memberInfoModel?.nickName != null
                  ? FractionallySizedBox(
                      alignment: Alignment.topLeft,
                      widthFactor: 0.55,
                      child: xtText(
                          widget._memberInfoModel?.nickName, 14, mainBlackColor,
                          overflow: TextOverflow.ellipsis),
                    )
                  : Container(),
            ),
            if ((widget._memberInfoModel != null &&
                !widget._memberInfoModel.isSelf))
              GestureDetector(
                child: _isAttention
                    ? _buildShapeText("已关注", 12, main66GrayColor,
                        main66GrayColor, EdgeInsets.fromLTRB(5, 0, 5, 1),
                        isSold: false)
                    : _buildShapeText("+ 关注", 12, xtColor_FFE60113,
                        xtColor_FFE60113, EdgeInsets.fromLTRB(5, 0, 5, 1),
                        isSold: false),
                onTap: () {
                  widget.clickAttention();
                },
              ),
            _buildIconButton(
                R.imagesLiveLiveAnchorTopWhiteShare, 22, widget.clickShare)
          ],
        ),
      ),
    );
  }
}

///吸顶和非吸顶的tabbar
class AnchorTabBar extends StatefulWidget {
  final TabController tabController;
  final bool isStick;
  final int currentTab;

  AnchorTabBar(Key key, this.tabController, this.isStick, this.currentTab)
      : super(key: key);

  @override
  _AnchorTabBarState createState() => _AnchorTabBarState(currentTab);
}

class _AnchorTabBarState extends State<AnchorTabBar> {
  int _currentTab;
  bool _showStickTabView = false;

  _AnchorTabBarState(this._currentTab);

  void setCurrentTab(int tab) {
    _currentTab = tab;
    setState(() {});
  }

  void showStickView(show) {
    _showStickTabView = show;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStick && !_showStickTabView) return _buildEmptyView();

    return TabBar(
      labelPadding: EdgeInsets.zero,
      controller: widget.tabController,
      unselectedLabelColor: xtColor_B3FFFFFF,
      indicatorColor: Colors.transparent,
      tabs: <Widget>[
        _buildSingleTabview(widget.isStick, "口碑秀", 0),
        _buildSingleTabview(widget.isStick, "直播回放", 1),
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
                  ? Border.symmetric(
                      vertical: BorderSide(color: mainF5GrayColor))
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
              )),
        )
      ],
    );
  }
}

///底部列表
class AnchorListItem extends StatefulWidget {
  final MemberInfoModel _memberInfoModel;
  final int _currentTab;
  final Function goCommentPublish;
  final Function refreshPage;
  final Function likeOrCancelLike;

  AnchorListItem(Key key, this._memberInfoModel, this._currentTab,
      this.goCommentPublish, this.refreshPage, this.likeOrCancelLike)
      : super(key: key);

  @override
  _AnchorListItemState createState() =>
      _AnchorListItemState(_currentTab, _memberInfoModel);
}

class _AnchorListItemState extends State<AnchorListItem> {
  int _currentTab;
  bool _canPublish = false;
  MemberInfoModel _memberInfoModel;
  List<VideoReplayModel> _videoReplayList = List();
  List<CommentShowModel> _commentShowList = List();

  _AnchorListItemState(this._currentTab, this._memberInfoModel);

  void setVideoReplayList(List<VideoReplayModel> value,
      MemberInfoModel memberInfoModel, int currentTab) {
    _videoReplayList = value;
    _currentTab = currentTab;
    _memberInfoModel = memberInfoModel;
    setState(() {});
  }

  void setCommentShowList(List<CommentShowModel> value,
      MemberInfoModel memberInfoModel, int currentTab) {
    _commentShowList = value;
    _currentTab = currentTab;
    _memberInfoModel = memberInfoModel;
    setState(() {});
  }

  set canPublish(bool value) {
    _canPublish = value;
  }

  @override
  Widget build(BuildContext context) {
    if (_memberInfoModel == null)
      return SliverToBoxAdapter(child: _buildEmptyView());
    if (_currentTab == 1) {
      //todo 缺少主播拉黑样式,不知道字段
      if ("主播被拉黑" == "主播没有拉黑") {
        return SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 105,
              ),
              xtText("该主播涉嫌播放违规信息，\n个人页面禁止访问！", 14, mainBlackColor),
              SizedBox(
                height: 45,
              ),
              _buildShapeText("查看其它直播", 15, mainBlackColor, mainBlackColor,
                  EdgeInsets.symmetric(vertical: 13, horizontal: 40),
                  isSold: false, radius: 3)
            ],
          ),
        );
      } else if (_videoReplayList != null && _videoReplayList.length > 0) {
        return SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext ctx, int index) {
          return _buildReplayListView(index);
        }, childCount: _videoReplayList.length));
      } else {
        return SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              xtText("该主播暂时还没有直播哦～", 14, mainBlackColor),
              SizedBox(
                height: 40,
              ),
              _buildShapeText("查看其它直播", 15, mainBlackColor, mainBlackColor,
                  EdgeInsets.symmetric(vertical: 13, horizontal: 40),
                  isSold: false, radius: 3)
            ],
          ),
        );
      }
    } else {
      if (_commentShowList != null && _commentShowList.length > 0) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverStaggeredGrid.countBuilder(
              crossAxisCount: 4,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              staggeredTileBuilder: (index) =>
//              StaggeredTile.count(2, index==0 ? 2 : 4),
                  StaggeredTile.fit(2),
              itemBuilder: (context, index) => _buildCommentShowListView(index),
              itemCount: _commentShowList.length),
        );
      } else {
        return SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 105,
              ),
              Image.asset(
                R.imagesDefaultHeaderImg,
                height: 90,
                width: 90,
              ),
              SizedBox(
                height: 20,
              ),
              xtText(
                  widget._memberInfoModel.isSelf && _canPublish
                      ? "暂无内容，赶快发布口碑秀积攒人气吧～"
                      : "暂无口碑秀内容",
                  14,
                  main99GrayColor),
              SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: widget._memberInfoModel.isSelf && _canPublish,
                  child: GestureDetector(
                    child: _buildShapeText(
                        "发布口碑秀",
                        16,
                        mainRedColor,
                        mainRedColor,
                        EdgeInsets.symmetric(vertical: 13, horizontal: 50),
                        isSold: false,
                        radius: 8),
                    onTap: () {
                      widget.goCommentPublish();
                    },
                  ))
            ],
          ),
        );
      }
    }
  }

  ///页面滑动内容列表(直播回放)
  _buildReplayListView(int index) {
    var replayModel = _videoReplayList[index];
    var liveInfo = replayModel?.liveInfo;
    var statistics = replayModel?.statistics;
    return GestureDetector(
      child: Container(
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
                    xtText("${liveInfo?.title ?? ""}", 16, mainBlackColor,
                        fontWeight: FontWeight.w600),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        _buildShapeText("回放", 12, whiteColor, xtColor_4D88FF,
                            EdgeInsets.fromLTRB(10, 0, 10, 1),
                            margin: EdgeInsets.only(right: 8)),
                        xtText(
                            "人气 ${NumberUtils.getStrToWan(statistics?.popularity ?? 0)} | ${liveInfo?.productIds?.length ?? "0"}商品",
                            12,
                            main99GrayColor)
                      ],
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
                xtText(
                    DateUtil.formatDateMs(liveInfo.startTime ?? "0",
                        format: "MM.dd"),
                    12,
                    main99GrayColor)
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
                  liveInfo?.liveCover ?? "",
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
      ),
      onTap: () {
        //todo 看不懂直播状态字段,分不清回放还是无回放结束,先统一跳回放
        XTRouter.pushToPage(
            routerName: "live-replay?id=${replayModel.liveInfo.id}",
            context: context,
            isNativePage: true);
      },
    );
  }

  ///页面滑动内容列表(口碑秀)
  _buildCommentShowListView(int index) {
    var commentShowModel = _commentShowList[index];
    bool isVideo = false;
    String url = '';
    int size;
    if (commentShowModel.videoUrlList.length > 0) {
      isVideo = true;
      url = commentShowModel.videoUrlList[0].url;
      size = commentShowModel.videoUrlList[0].size;
    } else {
      isVideo = false;
      url = commentShowModel.pictureUrlList[0].url;
      size = commentShowModel.pictureUrlList[0].size;
    }
    return GestureDetector(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: whiteColor,
        shape: xtShapeRound(10),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Stack(
                children: <Widget>[
                  _buildVideoOrPicItem(url, isVideo, commentShowModel),
                  if (isVideo)
                    Image.asset(
                      R.imagesLiveLiveIconPlay,
                      width: 38,
                      height: 38,
                    )
                ],
                alignment: Alignment.center,
              ),
//            child: AspectRatio(
//                aspectRatio: index % 2 == 0 ? 1 : 1440 / 800,
//                child: Image.network(index % 2 == 0
//                    ? "https://assets.hzxituan.com/supplier/77943E5ED2DCA759.jpg"
//                    : "http://yanxuan.nosdn.127.net/65091eebc48899298171c2eb6696fe27.jpg")),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  xtText(commentShowModel?.content ?? "", 14, mainBlackColor,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildHeadView(16, commentShowModel?.authorImage),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                          child: xtText(commentShowModel?.author ?? "", 10,
                              main66GrayColor,
                              overflow: TextOverflow.ellipsis)),
                      SizedBox(
                        width: 18,
                      ),
                      GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              commentShowModel.like
                                  ? R.imagesLiveLiveAnchorFavoriteRed
                                  : R.imagesLiveLiveAnchorFavoriteGray,
                              width: 14,
                              height: 14,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            xtText(
                                commentShowModel.like
                                    ? NumberUtils.getStrToWan(
                                        commentShowModel.likeUv)
                                    : "点赞",
                                12,
                                main66GrayColor),
                          ],
                        ),
                        onTap: () {
                          widget.likeOrCancelLike(commentShowModel.id);
                          commentShowModel.like = !commentShowModel.like;
                          if (commentShowModel.like) {
                            commentShowModel.likeUv =
                                commentShowModel.likeUv + 1;
                          } else {
                            commentShowModel.likeUv =
                                commentShowModel.likeUv - 1;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        XTRouter.pushToPage(
                routerName:
                    "goods_comment_detail?id1=${commentShowModel.id}&logtype1=profilepublish&productId1=${commentShowModel.productId}&content1=${commentShowModel.content}",
                context: context,
                isNativePage: true)
            .then((value) {
          widget.refreshPage();
        });
      },
    );
  }

  _buildVideoOrPicItem(
      String url, bool isVideo, CommentShowModel commentShowModel) {
    if (isVideo) {
      //不加入缓存会build会闪烁
      if (commentShowModel.uint8list != null) {
        return Image.memory(
          commentShowModel.uint8list,
          fit: BoxFit.fitWidth,
        );
      }
      return FutureBuilder<Uint8List>(
          initialData: null,
          future: VideoThumbnail.thumbnailData(
              video: url, quality: 25, maxWidth: 300),
          builder: (ctx, result) {
            if (result.data != null) {
              commentShowModel.uint8list = result.data;
              return Image.memory(
                commentShowModel.uint8list,
                fit: BoxFit.fitWidth,
              );
            } else {
              return SizedBox(
                height: 60,
              );
            }
          });
    } else {
      return Image.network(
        url,
        fit: BoxFit.fitWidth,
      );
    }
  }
}

_buildEmptyView() {
  return SizedBox.shrink();
}

_buildHeadView(double imageWidth, String headImage) {
  if (headImage != null && headImage != "") {
    headImage = headImage.contains("tximg")
        ? "https://sh-tximg.hzxituan.com/$headImage"
        : "https://assets.hzxituan.com/$headImage";
    return xtRoundAvatarImage(imageWidth, 100, "$headImage");
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: Image.asset(
        R.imagesDefaultHeaderImg,
        width: imageWidth,
        height: imageWidth,
      ),
    );
  }
}

_buildIconButton(String name, double size, VoidCallback callback) {
  return IconButton(
      icon: Image.asset(name), iconSize: size, onPressed: callback);
}

_buildShapeText(String text, double fontSize, Color textColor, Color shapeColor,
    EdgeInsets padding,
    {EdgeInsets margin = EdgeInsets.zero,
    bool isSold = true,
    double radius = 50}) {
  return Container(
    margin: margin,
    padding: padding,
    decoration: isSold
        ? ShapeDecoration(color: shapeColor, shape: xtShapeRound(radius))
        : BoxDecoration(
            border: Border.all(
              color: shapeColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
    child: xtText(text, fontSize, textColor),
  );
}
