import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/home_limit_seckill.dart';
import 'package:xtflutter/net_work/home_request.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';

class LimitTimeSeckillPage extends StatefulWidget {
  static String routerName = "limitTimeSpick";

  @override
  _LimitTimeSeckillPageState createState() => _LimitTimeSeckillPageState();
}

class _LimitTimeSeckillPageState extends State<LimitTimeSeckillPage> with SingleTickerProviderStateMixin {

  /// 标签长度
  int _length = 0;
  /// 监听器
  TabController _tabController;
  /// 上一个索引
  int _lastIndex = 0;
  /// 数据列表
  List<LimitTimeSeckillModel> _dataList = [];

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
    int defaultIndex = result["defaultIndex"];
    if (_dataList.isNotEmpty) {
      _length = _dataList.length;
      _tabController = TabController(length: _length, vsync: this, initialIndex: defaultIndex);
      _tabController.addListener(() {
        if (_lastIndex != _tabController.index) {
          _lastIndex = _tabController.index;
        }
      });
      setState(() {});
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
        Container()
      );     
    });
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
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0x70FFFFFF),
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
    );
  }
}