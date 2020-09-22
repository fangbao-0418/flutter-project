import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/home_limit_seckill.dart';
import 'package:xtflutter/net_work/home_request.dart';
import 'package:xtflutter/pages/home/limit_time_seckill_share.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xtflutter/utils/appconfig.dart';

class LimitTimeSeckillPage extends StatefulWidget {
  static String routerName = "limitTimeSeckill";

  @override
  _LimitTimeSeckillPageState createState() => _LimitTimeSeckillPageState();
}

class _LimitTimeSeckillPageState extends State<LimitTimeSeckillPage> with SingleTickerProviderStateMixin {

  /// 标签长度
  int _length = 0;
  /// 默认选中
  int _defaultIndex = 0;
  /// 监听器
  TabController _tabController;
  /// 上一个索引
  int _lastIndex = 0;
  /// 数据列表
  List<LimitTimeSeckillModel> _dataList = [];
  /// GlobalKey列表
  List<GlobalKey<_LimitTimeSeckillListPageState>> globlKeys = [];

  @override
  void initState() {
    super.initState();
    _getSeckillList();
  }

  @override
  void dispose() {
    super.dispose();

  }

  /// 获取时间及列表
  void _getSeckillList() async {
    Loading.show(context: context, showShade: true);
    Map<String, dynamic> result = await HomeRequest.getSeckillListReq({"page": 1}).whenComplete(() {
      Loading.hide();
    });
    _dataList = result["dataList"];
    _defaultIndex = result["defaultIndex"];
    if (_dataList.isNotEmpty) {
      _length = _dataList.length;
      _tabController = TabController(length: _length, vsync: this);
      _tabController.addListener(() {
        if (_lastIndex != _tabController.index) {
          _changeSeckillIndex(_tabController.index);
          _lastIndex = _tabController.index;
        }
      });
      setState(() {});
      Timer(Duration(milliseconds: 50), () {
        _tabController.index = _defaultIndex;
      });
    }
  }

  void _changeSeckillIndex(int index) async {
    Timer(Duration(milliseconds: 100), () {
      globlKeys[index].currentState.updateProductList();
    });
  }

  /// 分享 
  void _shareAction() async{    
    if (!AppConfig.isLogin) {
      /// 未登录，跳转登录页
      XTRouter.pushToPage(routerName: "gotoLogin", context: context, isNativePage: true);
      return;
    }
    Loading.show();
    String mid = AppConfig.user.mid;
    ShareCardInfoModel shareModel = await HomeRequest.getCardInfo({"page": "pages/seckill/index", "scene": "mid=" + mid})
    .whenComplete(() => Loading.hide());
    shareModel.setMid(mid);

    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return LimitTimeSeckillSharePage(productList: globlKeys[_lastIndex].currentState.productList, shareModel: shareModel);
      },
    ));
  }

  /// 获取时间列表
  List<Widget> _getTimeTabs() {
    List<Widget> childred = [];
    _dataList.forEach((e) {
      childred.add(
        Container(
          height: 48,
          child: Tab(
            iconMargin: EdgeInsets.only(bottom: 3),
            icon: Text(e.promotionStartTimeDesc, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            child: Text(e.desc, style: TextStyle(fontSize: 11)),
          ),
        )
      );     
    });
    return childred;
  }

  List<Widget> _getViewTabs() {
    List<Widget> childred = [];
    for (var i = 0; i < _dataList.length; i++) {
      GlobalKey<_LimitTimeSeckillListPageState> listPageStateKey = GlobalKey<_LimitTimeSeckillListPageState>();
      childred.add(
        Container(
          child: LimitTimeSeckillListPage(infoModel: _dataList[i], seckillIndex: i, key: listPageStateKey),
        )
      );
      globlKeys.add(listPageStateKey);
    }
    return childred;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _length, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainRedColor,
          elevation: 0,
          leading: IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.arrow_back,
              size: 22,
            ),
            onPressed: () => XTRouter.closePage(context: context),
          ),
          title: xtText("限时秒杀", 18, Colors.white),
          bottom: _length > 0 ? TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: xtColor_B3FFFFFF,
            indicatorColor: Colors.transparent,
            isScrollable: true,
            onTap: (int index) {
              _lastIndex = index;
            },
            tabs: _getTimeTabs()
          ) : null,
        ),
        body: _length > 0 ? Stack(
          children: <Widget>[
            TabBarView(
              controller: _tabController,
              children: _getViewTabs(),
            ),
            Positioned(
              bottom: 160,
              right: 0,
              child: FlatButton(
                onPressed: () {
                  _shareAction();
                }, 
                padding: EdgeInsets.zero,
                child: Image.asset("images/limit_time_seckill_share.png")
              ),
            )
          ],
        ) : Center(child: xtText("暂无限时秒杀商品~", 16, xtColor_969696)),
      ),
    );
  }
}

class LimitTimeSeckillListPage extends StatefulWidget {
  LimitTimeSeckillListPage({this.infoModel, this.seckillIndex, Key key}) : super(key: key);

  final LimitTimeSeckillModel infoModel;
  final int seckillIndex;

  @override
  _LimitTimeSeckillListPageState createState() => _LimitTimeSeckillListPageState();
}

class _LimitTimeSeckillListPageState extends State<LimitTimeSeckillListPage> with AutomaticKeepAliveClientMixin {
  /// 数据源列表
  List<LimitTimeSeckillProductModel> _productList = [];
  /// 刷新器
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  /// 页码
  int _pageIndex = 1;
  /// 营销id
  int _promotionId = 0;
  /// 索引
  int _seckillIndex = 0;
  /// 开抢状态
  SeckillStatus _status = SeckillStatus.buying;
  /// 是否是第一次加载
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _productList = widget.infoModel.products;
    _promotionId = widget.infoModel.promotionId;
    _seckillIndex = widget.seckillIndex;
    _status = widget.infoModel.seckillStatus;
  }

  /// 重写setState方法
  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  /// 保持当前页面存活
  @override
  bool get wantKeepAlive => true;

  /// 获取商品列表
  List<LimitTimeSeckillProductModel> get productList => _productList;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return (_productList.isEmpty && !_isFirstLoad) ? 
    Center(child: xtText("该场次暂无限时秒杀商品~", 16, xtColor_969696)) :
    Container(
      child: _getListView(_productList),
    );
  }

  /// 更新数据源
  void updateProductList() async {
    if (!(_productList == null || _productList.isEmpty)) {
      return;
    }
    _isFirstLoad = false;
    getProductListReq();
  }

  /// 请求数据
  void getProductListReq({bool isFirst = true}) async {
    if (_pageIndex == 1) { Loading.show(); }
    Map<String, dynamic> result = await HomeRequest.getSeckillListReq({"page": _pageIndex, "promotionId": _promotionId})
    .whenComplete(() {
      Loading.hide();
    });
    List<LimitTimeSeckillModel> list = result["dataList"];
    List<LimitTimeSeckillProductModel> products = list[_seckillIndex].products;
    setState(() {
      if (_pageIndex == 1) {
        _productList = products;
      } else {
        _productList.addAll(products);
      }
    });
    if (!isFirst) {
        if (products.length < 10) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      }
  }

  /// 上拉加载
  void _onLoading() {
    _pageIndex ++;
    getProductListReq(isFirst: false);
  }

  /// 点击操作
  void _clickAction(LimitTimeSeckillProductModel model) async {
    switch (_status) {
      case SeckillStatus.noStart:
        Map<String, dynamic> params = {
          "productName": model.productName,
          "promotionId": _promotionId,
          "productId": model.productId,
          "platform": AppConfig.osPlatform,
          "type": model.isSub ? 1 : 0
        };
        String result = await HomeRequest.seckillMegSub(params);
        Toast.showToast(msg: result);
        setState(() {
          model.isSub = !model.isSub;
        });
        break;
      default:
        _gotoDetail(model);
    }
  }

  /// 前往详情页面
  void _gotoDetail(LimitTimeSeckillProductModel model) {
    XTRouter.pushToPage(
      routerName: "goods-detail?id=${model.productId}", 
      context: context, 
      isNativePage: true
    );
  }

  /// 获取列表widget
  Widget _getListView(List<LimitTimeSeckillProductModel> products) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus mode){
          Widget body ;
          if(mode==LoadStatus.idle){
            body =  Text("上拉加载");
          }
          else if(mode==LoadStatus.loading){
            body =  CupertinoActivityIndicator();
          }
          else if(mode == LoadStatus.failed){
            body = Text("加载失败，请重试");
          }
          else if(mode == LoadStatus.canLoading){
            body = Text("松开加载");
          }
          else{
            body = xtText("—— 没有更多内容了哦 ——", 12, mainA8GrayColor);
          }
          return Container(
            padding: EdgeInsets.only(bottom: AppConfig.bottomH),
            height: 55.0 + AppConfig.bottomH,
            child: Center(child:body),
          );
        },
      ),
      onLoading: _onLoading,
      child: ListView.builder(
        itemExtent: 145,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _getCellWithModel(products[index]);
        }
      ),
    );
  }

  /// 获取单元格widget
  Widget _getCellWithModel(LimitTimeSeckillProductModel model) {
    return GestureDetector(
      onTap: () => _gotoDetail(model),
      child: Card(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
        color: Colors.white,
        shape: xtShapeRound(8),
        elevation: 0,
        child: Row(
          children: <Widget>[
            SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Stack(
                children: <Widget>[
                  xtRoundAvatarImage(110, 8, model.coverImage, borderColor: mainF5GrayColor, borderWidth: 0.5),
                  /// 4个角落上的标签
                  Visibility(
                    visible: model.tagType == TagPositionType.leftTop,
                    child: Positioned(left: 0, top: 0,
                      child: Image(image: NetworkImage(model.tagUrl), width: 50, height: 30)
                    )
                  ),
                  Visibility(
                    visible: model.tagType == TagPositionType.leftBottom,
                    child: Positioned(left: 0, bottom: 0,
                      child: Image(image: NetworkImage(model.tagUrl), width: 50, height: 30)
                    )
                  ),
                  Visibility(
                    visible: model.tagType == TagPositionType.rightTop,
                    child: Positioned(right: 0, top: 0,
                      child: Image(image: NetworkImage(model.tagUrl), width: 50, height: 30)
                    )
                  ),
                  Visibility(
                    visible: model.tagType == TagPositionType.rightBottom,
                    child: Positioned(right: 0, bottom: 0,
                      child: Image(image: NetworkImage(model.tagUrl), width: 50, height: 30)
                    )
                  ),
                  Visibility(
                    visible: (model.isSellOut && _status != SeckillStatus.noStart),
                    child: Container(
                      alignment: Alignment.center,
                      height: 110,
                      width: 110,
                      decoration: xtRoundDecoration(8, bgcolor: Color(0x7D000000)),
                      child: Image(
                        width: 68,
                        height: 68,
                        fit: BoxFit.fitWidth,
                        image: AssetImage("images/product-sellOut-small.png"),
                      ),
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Visibility(
                                  visible: (model.limitNumber != null && model.limitNumber >= 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage("images/pintuan_two.png"),
                                        height: 15,
                                      ),
                                      SizedBox(width: 2)
                                    ],
                                  ),
                                )
                              ),
                              WidgetSpan(
                                child: Visibility(
                                  visible: model.productImgName.isNotEmpty,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage(model.productImgName),
                                        height: 15,
                                      ),
                                      SizedBox(width: 2)
                                    ],
                                  ),
                                )
                              ),
                              TextSpan(
                                text: model.productName,
                                style: xtstyle(14, mainBlackColor),
                              )
                            ]
                          )
                        ),
                        SizedBox(height: 5),
                        Visibility(
                          visible: _status == SeckillStatus.noStart,
                          child: Row(
                            children: <Widget>[
                              xtText(model.limitNumText, 12, main99GrayColor),
                            ],
                          )
                        ),
                        Visibility(
                          visible: _status != SeckillStatus.noStart,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      child: Container(
                                        width: 100,
                                        height: 12,
                                        color: xtColor_4DE60113,
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(model.sellRatio >= 0.2 ? 6 : 0),
                                        bottomRight: Radius.circular(model.sellRatio >= 0.2 ? 6 : 0),
                                      ),
                                      child: Container(
                                        width: 100 * model.sellRatio,
                                        height: 12,
                                        color: mainRedColor,
                                      ),
                                    ),
                                    xtText(model.sellText, 9, Colors.white, fontWeight: FontWeight.w500)
                                  ],
                                ),
                              ),
                              xtText(model.sellCountText, 10, mainBlackColor)
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (AppConfig.isLogin && AppConfig.user.memberType != null && AppConfig.user.memberType >= 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.only(left: 2, right: 2),
                                alignment: Alignment.centerLeft,
                                child: xtText(model.mostEarnText, 10, xtColor_FF6600, alignment: TextAlign.center),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                  border: Border.all(
                                    color: xtColor_FF6600,
                                    width: 0.5
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              xtText(
                                "¥", 
                                18, 
                                _status == SeckillStatus.noStart ? xtColor_33AB33 : mainRedColor, 
                                fontWeight: FontWeight.w500, 
                                alignment: TextAlign.center
                              ),
                              xtText(
                                model.buyingPriceText, 
                                24, 
                                _status == SeckillStatus.noStart ? xtColor_33AB33 : mainRedColor, 
                                fontWeight: FontWeight.w500, 
                                alignment: TextAlign.center
                              ),
                              Text(
                                model.marketPriceText,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: mainA8GrayColor,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: mainA8GrayColor
                                ),
                              ),
                            ],
                          ),
                          ButtonTheme(
                            minWidth: 0,
                            child: FlatButton(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              color: (_status == SeckillStatus.noStart || model.isSellOut) ? Colors.white : mainRedColor,
                              shape: _status == SeckillStatus.noStart ? 
                                xtShapeRoundLineCorners(
                                  radius: 6, 
                                  lineColor: (model.isSub ? xtColor_7D33AB33 : xtColor_33AB33), 
                                  lineWidth: 1
                                ) 
                                : (model.isSellOut ? 
                                    xtShapeRoundLineCorners(
                                      radius: 6, 
                                      lineColor: mainA8GrayColor, 
                                      lineWidth: 1
                                  ) 
                                  : xtShapeRound(6)
                                ),
                              onPressed: () => _clickAction(model),
                              child: xtText(
                                _status == SeckillStatus.noStart ? (model.isSub ? "取消提醒" : "提醒我") : (model.isSellOut ? "已售罄" : "立即抢"), 
                                14, 
                                _status == SeckillStatus.noStart ? (model.isSub ? xtColor_7D33AB33 : xtColor_33AB33) : (model.isSellOut ? mainA8GrayColor : Colors.white) 
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}