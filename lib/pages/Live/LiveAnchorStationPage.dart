import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/LiveStationAnchorInfo.dart';
import 'package:xtflutter/net_work/live_request.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';
import 'package:intl/intl.dart';

class LiveAnchorStationPage extends StatefulWidget {
  static String routerName = "LiveAnchorStationPage";
  @override
  _LiveAnchorStationPageState createState() => _LiveAnchorStationPageState();
}

class _LiveAnchorStationPageState extends State<LiveAnchorStationPage> {
  String navTitle = "喜团优选直播";
  //主播信息模型
  LiveStationAnchorModel anchorModel = LiveStationAnchorModel();
  List livePlan = [];
  List liveHistory = [];

  @override
  void initState() {
    // TODO: implement initState
    debugDumpApp();
    print("liveStationHeight:${AppConfig.getInstance()}");
    super.initState();
    getAnchorInfoReq();
    getLiveStationInfoReq();
  }

  void getAnchorInfoReq() async{

    Loading.show(context: context, showShade: true);
    Map<String, dynamic> result = await LiveRequest.getUserInfoData().whenComplete(() {
      Loading.hide();
    });

    anchorModel = LiveStationAnchorModel.fromJson(result);
    print("anchorModel:"+ anchorModel.toString());
    setState(() {});
  }

  void getLiveStationInfoReq() async{

    Loading.show(context: context, showShade: true);
    Map<String, dynamic> result = await LiveRequest.getLiveInfoData().whenComplete(() {
      Loading.hide();
    });

    print("liveStationResult:"+ result.toString());

    livePlan.clear();
    liveHistory.clear();
    List planList = result["livePlans"];
    List historyList = result["liveHistorys"];

    for(var i = 0; i < planList.length; i++){
      var json = planList[i];
      LivePlanHistoryModel model = LivePlanHistoryModel.fromJson(json);
      livePlan.add(model);
      print("livePlan:"+model.toString());
    }

    for(var i = 0; i < historyList.length; i++){
      var json = historyList[i];
      LivePlanHistoryModel model = LivePlanHistoryModel.fromJson(json);
      liveHistory.add(model);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("liveStationHeight:${AppConfig.navH}");
    return Scaffold(
        body: Stack(children: <Widget>[
          obtainTopBgImage(),
          obtainLiveAppBar(),
          obtainListViewContainer(),
        ],
        ));
  }

  //直播信息cell
  Widget obtainLiveStationCell(LivePlanHistoryModel model){
    return Container(
      margin: EdgeInsets.only(top: 10,left: 12,right: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: whiteColor),
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
                      bottomLeft: Radius.circular(10)
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "",
                    image: model.liveCover,
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
                      xtText(model.title, 14, mainBlackColor,maxLines: 2),
                      xtText( "直播时间："+ DateFormat("yyyy.MM.dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(model.startTime)), 12, main99GrayColor),
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

  Widget obtainLiveStatusWidget(LivePlanHistoryModel model){
    if (model.status != 2){
      return Container(
          margin: EdgeInsets.all(6),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                  begin:Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: [
                    xtColor_00CC88,
                    xtColor_29D69D
                  ]
              )
          ),
          child: xtText(model.getStatusText(),10,whiteColor)
      );
    }else{
      return Container(
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
                  child: xtText(model.getStatusText(), 10, whiteColor)
              ),
              Container(
                padding: EdgeInsets.all(3),
                child: xtText(
                    "人气" +
                        (NumUtil.getNumByValueDouble(
                                model.statistics.popularity / 1000, 2))
                            .toStringAsFixed(2) +
                        "W",
                    10,
                    whiteColor),
              )
            ],
          ));
    }
  }

  // 编辑和进入直播间按钮
  Widget obtainLiveActionBtn(LivePlanHistoryModel model){
    return Row(
      children: <Widget>[
        Container(
          width: 72,
          height: 22,
          child: OutlineButton(
            borderSide: BorderSide(
              color: mainRedColor,
            ),
            child: xtText("编辑",12, mainRedColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onPressed: (){
              Toast.showToast(msg: "编辑");
            },
          ),
        ),
        Container(
          width: 72,
          height: 22,
          margin: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
              color: mainRedColor,
              borderRadius: BorderRadius.circular(6)
          ),
          child: FlatButton(
            child: xtText("进入直播间",12, whiteColor),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onPressed: (){
              Toast.showToast(msg: "进入直播间");
            },
          ),
        )
      ],
    );
  }

  //滚动列表view
  Widget obtainListViewContainer(){
    return Container(
        padding: EdgeInsets.only(top: AppConfig.navH),
        child: ListView.builder(
            padding: EdgeInsets.only(top: 0),
            itemCount: livePlan.length + 1 + liveHistory.length + 1,
            itemBuilder: (context, index) {

              if (index == 0) {
                return obtainProfileWidget();
              } else {
                if (index <= livePlan.length ) {
                  final model = livePlan[index-1];
                  return obtainLiveStationCell(model);
                }else if (index == livePlan.length + 1){
                  return Container(
                    margin: EdgeInsets.only(left: 12,top: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 6),
                            child: xtText("历史数据", 14, Colors.black)
                        ),
                        xtText("过期数据保存3个月，结束保存N个月", 12, main99GrayColor),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Row(
                            children: <Widget>[
                              xtText("更多", 12, main99GrayColor),
                              Image.asset("images/live_station_arrow_right.png")
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }else{
                  final model = liveHistory[index - livePlan.length - 2];
                  return obtainLiveStationCell(model);
                }
              }
            }
        )
    );
  }

  //顶部背景图片
  Widget obtainTopBgImage(){
    return Container(
        width: double.infinity,
        child: Image(
          image: AssetImage("images/live_station_top_bg.png"),
          fit: BoxFit.fitWidth,
        ));
  }

  Widget obtainLiveAppBar() {
    return Container(
      height: AppConfig.navH,
      child: AppBar(
        backgroundColor: Colors.transparent,
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
        title: GestureDetector(
          child: Row(
            children: <Widget>[
              Spacer(flex: 2),
              xtText(navTitle, 18, whiteColor),
              Container(
                child: Image.asset("images/live_station_arrow_down.png"),
                margin: EdgeInsets.only(left: 5),
              ),
              Spacer(flex: 2),
            ],
          ),
          onTap: () {
            Toast.showToast(msg: "切换直播类型", context: context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            textColor: whiteColor,
            child: Text("我的店铺", style: xtstyle(14, whiteColor)),
            onPressed: () {
              Toast.showToast(msg: "我的店铺", context: context);
            },
          ),
        ],
      ),
    );
  }

  //主播信息
  Widget obtainProfileWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 12),
              width: 48,
              height: 48,
              child: CircleAvatar(
                  radius: 24,
                  child: FadeInImage(
                      placeholder: AssetImage("images/empty.png"),
                      image: NetworkImage(anchorModel.coverUrl)
                  )
//              child: Image.asset(""),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: xtText(anchorModel.nickName, 16, whiteColor),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset("images/live_star.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 2,right: 8),
                        child: xtText("星级主播", 12, whiteColor),
                      ),
                      Visibility(
                        visible: anchorModel.fansNum > 0,
                          child: xtText("${anchorModel.fansNum}粉丝", 12, whiteColor)
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(top: 10,bottom: 0,left: 12,right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: xtColor_F7F7F7,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset("images/live_notify_horn.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 6,right: 10),
                      child: xtText("主播分佣制度上线，成为喜团主播有钱赚啦！", 12, xtColor_E60146),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        xtText("¥12.45W", 18, mainBlackColor),
                        Row(
                          children: <Widget>[
                            xtText("累计佣金", 12, xtColor_A8A8A8),
                            Icon(Icons.chevron_right,color: xtColor_A8A8A8,size: 20,)
                          ],
                        )
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: xtColor_F5F5F5,
                    ),
                    Column(
                      children: <Widget>[
                        xtText("¥12.45W", 18, mainBlackColor),
                        Row(
                          children: <Widget>[
                            xtText("待结算佣金", 12, xtColor_A8A8A8),
                            Icon(Icons.chevron_right,color: xtColor_A8A8A8,size: 20,)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

