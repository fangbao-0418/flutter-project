import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/home_limit_seckill.dart';
import 'package:xtflutter/net_work/home_request.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LimitTimeSeckillPage extends StatefulWidget {
  static String routerName = "limitTimeSpick";

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

  LimitTimeSeckillProductModel _providerModel;

  @override
  void initState() {
    super.initState();
    _getSeckillList();
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
          _lastIndex = _tabController.index;
        }
      });
      setState(() {});
      Timer(Duration(milliseconds: 50), () {
        _tabController.index = _defaultIndex;
      });
    }
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
            icon: Text(e.promotionStartTimeDesc, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            child: Text(e.desc, style: TextStyle(fontSize: 10)),
          ),
        )
      );     
    });
    return childred;
  }

  List<Widget> _getViewTabs() {
    List<Widget> childred = [];
    _dataList.forEach((e) {
      childred.add(
        Container(
          child: LimitTimeSeckillListPage(infoModel: e),
        )
      );     
    });
    return childred;
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (ctx) => _providerModel,
      child: DefaultTabController(
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
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: xtColor_B3FFFFFF,
              indicatorColor: Colors.transparent,
              isScrollable: true,
              onTap: (int index) {
                _lastIndex = index;
              },
              tabs: _getTimeTabs()
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: _getViewTabs(),
          ),
        ),
      ),
    );
  }
}



class LimitTimeSeckillListPage extends StatefulWidget {
  LimitTimeSeckillListPage({this.infoModel});

  final LimitTimeSeckillModel infoModel;
  

  @override
  _LimitTimeSeckillListPageState createState() => _LimitTimeSeckillListPageState();
}

class _LimitTimeSeckillListPageState extends State<LimitTimeSeckillListPage> with AutomaticKeepAliveClientMixin {
  /// 数据源列表
  List<LimitTimeSeckillProductModel> _productList = [];
  /// 刷新器
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _productList = widget.infoModel.products;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getListView(_productList),
    );
  }

  void _onLoading() async {

  }

  Widget _getListView(List<LimitTimeSeckillProductModel> products) {
    return ListView.builder(
      itemExtent: 142,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _getCellWithModel(products[index]);
      }
    );
  }

  Widget _getCellWithModel(LimitTimeSeckillProductModel model) {
    return Card(
      margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
      color: Colors.white,
      shape: xtShapeRound(8),
      elevation: 0,
      child: Row(
        children: <Widget>[
          SizedBox(width: 8),
          xtRoundAvatarImage(110, 8, model.coverImage),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      xtText(model.productName, 14, mainBlackColor, maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: xtColor_4DE60113,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                              ),
                              Container(
                                width: 100 * model.sealsRatio,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: mainRedColor,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                              ),
                              xtText(model.sealsText, 9, Colors.white, fontWeight: FontWeight.w500)
                            ],
                          ),
                          xtText(model.sealsCountText, 10, mainBlackColor)
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
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
                  Container(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            xtText("¥", 18, mainRedColor, fontWeight: FontWeight.w500, alignment: TextAlign.center),
                            xtText((model.buyingPrice / 100).toString(), 24, mainRedColor, fontWeight: FontWeight.w500, alignment: TextAlign.center),
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
                        FlatButton(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          color: mainRedColor,
                          shape: xtShapeRound(6),
                          onPressed: () {
                            Toast.showToast(msg: "null");
                          },
                          child: xtText("立即抢", 14, Colors.white),
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
    );
  }
}