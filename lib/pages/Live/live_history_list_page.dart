import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/live_anchor_model.dart';
import 'package:xtflutter/pages/normal/refresh.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/net_work/live_request.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';

import '../../r.dart';

class LiveHistoryListPage extends StatefulWidget {
  static String routerName = "LiveHistoryListPage";

  final Map <String,dynamic> params;
  LiveHistoryListPage({this.params});

  @override
  _LiveHistoryListPageState createState() => _LiveHistoryListPageState();
}

class _LiveHistoryListPageState extends State<LiveHistoryListPage> {

  /// 页码
  int _pageIndex = 1;
  int _pageSize = 10;

  int liveType;

  List <LivePlanHistoryModel> liveHistory = [];

  EasyRefreshController _controller = EasyRefreshController();

  /// 获取列表widget
  Widget _getListView(List<LivePlanHistoryModel> products) {
    return XTRefresh(
      controller: _controller,
      onRefresh: _getListData,
      onLoad: _onLoading,
      child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            LivePlanHistoryModel model = liveHistory[index];
            return obtainLiveStationCell(model);
          }
      ),
    );
  }

  //直播信息cell
  Widget obtainLiveStationCell(LivePlanHistoryModel model) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: whiteColor),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: FadeInImage(
                    placeholder: AssetImage(R.imagesEmpty),
                    image: NetworkImage(model.liveCover),
                  ),
                ),
              ),
              obtainLiveStatusWidget(model)
            ],
          ),
          Expanded(
            child: Container(
              height: 120,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      xtText(model.title, 14, mainBlackColor, maxLines: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          xtText("直播时间：", 12, main99GrayColor),
                          xtText(
                              model.getTimeText(),
                              12,
                              main99GrayColor,
                              maxLines: 2),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  obtainLiveActionBtn(model)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget obtainLiveStatusWidget(LivePlanHistoryModel model) {
    if (model.isHistoryModel == false) {
      return Stack(
        children: <Widget>[
          // 待开播和待审核
          Visibility(
            visible: model.status == 0 || model.status == 1,
            child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                        colors: [xtColor_00CC88, xtColor_29D69D])),
                child: xtText(model.getStatusText(), 10, whiteColor)),
          ),

          //草稿
          Visibility(
            visible: !(model.status == 0 || model.status == 1),
            child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: xtColor_80000000,
                ),
                child: xtText(model.getStatusText(), 10, whiteColor)),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Visibility(
            visible: model.status == 1,
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: xtColor_80000000,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight,
                              colors: [xtColor_4D88FF, xtColor_6E9EFF])),
                      child: xtText(model.getStatusText(), 10, whiteColor)),
                  Container(
                    padding: EdgeInsets.all(3),
                    child: xtText(
                        model.getPVString(),
                        10,
                        whiteColor),
                  )
                ],
              ),
            ),
          ),
          //过期
          Visibility(
            visible: model.status == 0,
            child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: xtColor_80000000,
                ),
                child: xtText(model.getStatusText(), 10, whiteColor)),
          ),
          //禁播 未过审
          Visibility(
            visible: model.status == 2 || model.status == 3,
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [mainRedColor, xtColor_FFEB2D3C]),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight,
                              colors: [mainRedColor, xtColor_FFEB2D3C]
                          )
                      ),
                      child: xtText(model.getStatusText(), 10, whiteColor)
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 2,right: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: whiteColor,width: 1)
                    ),
                    child: xtText("!", 10, whiteColor),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  // 编辑和进入直播间按钮
  Widget obtainLiveActionBtn(LivePlanHistoryModel model) {
    return Row(
      children: <Widget>[
        Container(
          width: 72,
          height: 22,
          child: OutlineButton(
            padding: EdgeInsets.all(0),
            borderSide: BorderSide(
              color: mainRedColor,
            ),
            child: xtText(model.isEditBtn() ? "编辑" : "查看", 12, mainRedColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onPressed: () {
              if (model.isEditBtn()) {
                Toast.showToast(msg: "编辑");
              } else {
                Toast.showToast(msg: "查看");
              }
            },
          ),
        ),
        Visibility(
          visible: model.isHistoryModel == false &&
              (model.status == 1 || model.status == 3),
          child: Container(
            width: 72,
            height: 22,
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                color: mainRedColor, borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              child: xtText("进入直播间", 12, whiteColor),
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onPressed: () {
                Toast.showToast(msg: "进入直播间");
              },
            ),
          ),
        )
      ],
    );
  }


  void _getListData() async{

    _pageIndex = 1;

    _controller.finishLoad(noMore: false);

    Loading.show(context: context);
    List<dynamic> result =
        await LiveRequest.getLiveHistoryList(Map<String, dynamic>.from({"page":_pageIndex,"pageSize":_pageSize,"type":liveType})).whenComplete(() {
      Loading.hide();
    });

    print("liveHistoryResult:" + result.toString());

    liveHistory.clear();

    for (var i = 0; i < result.length; i++) {
      var json = result[i];
      LivePlanHistoryModel model = LivePlanHistoryModel.fromJson(json);
      model.isHistoryModel = true;
      liveHistory.add(model);
    }

    setState(() {});
  }

  void _getMoreListData() async{
    Loading.show(context: context);
    List<dynamic> result =
    await LiveRequest.getLiveHistoryList(Map<String, dynamic>.from({"page":_pageIndex,"pageSize":_pageSize,"type":liveType})).whenComplete(() {
      Loading.hide();
    });

    _controller.finishLoad(noMore: result.length < 10);

    print("liveHistoryResult:" + result.toString());

    for (var i = 0; i < result.length; i++) {
      var json = result[i];
      LivePlanHistoryModel model = LivePlanHistoryModel.fromJson(json);
      model.isHistoryModel = true;
      liveHistory.add(model);
    }

    setState(() {});
  }

  /// 上拉加载
  void _onLoading() {
    _pageIndex ++;
    _getMoreListData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liveType = widget.params["liveType"];
    _getListData();
  }

  Widget obtainLiveAppBar() {
    return AppBar(
      backgroundColor: mainRedColor,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        color: whiteColor,
        icon: Icon(
          Icons.arrow_back,
          size: 22,
        ),
        onPressed: () {
          XTRouter.closePage(context: context);
        },
      ),
      title: xtText("历史数据", 18, whiteColor),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: obtainLiveAppBar(),
      body: _getListView(liveHistory),
    );
  }
}
