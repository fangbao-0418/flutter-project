import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:xtflutter/r.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/LiveStationAnchorInfo.dart';
import 'package:xtflutter/net_work/live_request.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/router/router.dart';
import 'package:intl/intl.dart';
import 'package:xtflutter/utils/event_bus.dart';

class LiveAnchorStationPage extends StatefulWidget {
  static String routerName = "LiveAnchorStationPage";

  @override
  _LiveAnchorStationPageState createState() => _LiveAnchorStationPageState();
}

const String dialogCallBackName = "dialogCallBack";

class _LiveAnchorStationPageState extends State<LiveAnchorStationPage> {
  //直播类型 1.喜团优选 2 买菜直播
  int liveType = 1;
  String navTitle = "喜团优选直播";
  //主播信息模型
  LiveStationAnchorModel anchorModel;
  //直播计划数组
  List livePlan = [];
  //历史直播数组
  List liveHistory = [];
  //累计佣金金额
  int totalAmount = 0;
  //待结算佣金金额
  int unsettledAmount = 0;
  //累计佣金字符串
  String totalAmountString;
  //待结算佣金字符串
  String unsettledAmountString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnchorInfoReq();
    getLiveStationInfoReq();
    getSettleInfoReq();
  }

  void getAnchorInfoReq() async {
    Loading.show(context: context, showShade: true);
    Map<String, dynamic> result =
        await LiveRequest.getUserInfoData().whenComplete(() {
      Loading.hide();
    });

    if (result != null){
      anchorModel = LiveStationAnchorModel.fromJson(result);
    }
    print("anchorModel:" + anchorModel.toString());
    setState(() {});
  }

  void getSettleInfoReq() async {
    Loading.show(context: context,showShade: true);
    Map<String,dynamic> result = await LiveRequest.getSettleInfoData().whenComplete((){
      Loading.hide();
    });

    if (result != null){
      totalAmount = result["totalAmount"];
      if (totalAmount > 1000000){
        totalAmountString = MoneyUtil.changeF2YWithUnit(totalAmount~/10000,format: MoneyFormat.END_INTEGER,unit: MoneyUnit.YUAN) + "W";
      }else{
        totalAmountString = MoneyUtil.changeF2YWithUnit(totalAmount,format: MoneyFormat.END_INTEGER,unit: MoneyUnit.YUAN);
      }

      unsettledAmount = result["unsettledAmount"];
      if (unsettledAmount > 1000000){
        unsettledAmountString = MoneyUtil.changeF2YWithUnit(unsettledAmount~/10000,format: MoneyFormat.END_INTEGER,unit: MoneyUnit.YUAN) + "W";
      }else{
        unsettledAmountString = MoneyUtil.changeF2YWithUnit(unsettledAmount,format: MoneyFormat.END_INTEGER,unit: MoneyUnit.YUAN);
      }
    }

    setState(() {});
  }

  void getLiveStationInfoReq() async {
    Loading.show(context: context, showShade: true);
    Map<String, dynamic> result =
        await LiveRequest.getLiveInfoData(Map<String, dynamic>.from({"type":liveType})).whenComplete(() {
      Loading.hide();
    });

    print("liveStationResult:" + result.toString());

    livePlan.clear();
    liveHistory.clear();
    List planList = result["livePlans"];
    List historyList = result["liveHistorys"];

    for (var i = 0; i < planList.length; i++) {
      var json = planList[i];
      LivePlanHistoryModel model = LivePlanHistoryModel.fromJson(json);
      model.isHistoryModel = false;
      livePlan.add(model);
      print("livePlan:" + model.toString());
    }

    for (var i = 0; i < historyList.length; i++) {
      var json = historyList[i];
      LivePlanHistoryModel model = LivePlanHistoryModel.fromJson(json);
      model.isHistoryModel = true;
      liveHistory.add(model);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        obtainTopBgImage(),
        obtainLiveAppBar(),
        obtainListViewContainer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 56 + AppConfig.bottomH,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(top: 7,left: 18,right: 18,bottom: AppConfig.bottomH + 8),
            color: whiteColor,
            child: FlatButton(
                color: xtColor_E60146,
                child: xtText("创建直播", 16, whiteColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onPressed: (){
                  Toast.showToast(msg: "创建直播");
            }),
          ),
        )
      ],
    ));
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
                      xtText(
                          "直播时间：" +
                              DateFormat("yyyy.MM.dd HH:mm:ss").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      model.startTime)),
                          12,
                          main99GrayColor),
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
      return Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: xtColor_80000000,
          ),
          child: Stack(
            children: <Widget>[
              Visibility(
                visible: model.status == 1,
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
                          "人气" +
                              (NumUtil.getNumByValueDouble(
                                      model.statistics.popularity / 1000, 2))
                                  .toStringAsFixed(2) +
                              "W",
                          10,
                          whiteColor),
                    )
                  ],
                ),
              ),
              //过期
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
              //禁播 未过审
              Visibility(
                visible: model.status == 1,
                child: Row(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight,
                                colors: [mainRedColor, xtColor_FFEB2D3C])),
                        child: xtText("禁播", 10, whiteColor)
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: xtText("!", 10, whiteColor),
                    )
                  ],
                ),
              ),
            ],
          ));
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
            child: xtText(model.isEditBtn() ? "重新编辑" : "查看", 12, mainRedColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onPressed: () {
              if (model.isEditBtn()) {
                Toast.showToast(msg: "重新编辑");
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

  //滚动列表view
  Widget obtainListViewContainer() {
    print("bottomH:"+AppConfig.bottomH.toString());
    return Container(
        padding: EdgeInsets.only(top: AppConfig.navH,bottom: 56 + AppConfig.bottomH),
        child: ListView.builder(
            padding: EdgeInsets.only(top: 0),
            itemCount: livePlan.length + 1 + liveHistory.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return anchorModel != null ? obtainProfileWidget(anchorModel) : Container();
              } else {
                if (index <= livePlan.length) {
                  final model = livePlan[index - 1];
                  return obtainLiveStationCell(model);
                } else if (index == livePlan.length + 1) {
                  return Container(
                    margin: EdgeInsets.only(left: 12, top: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 6),
                            child: xtText("历史数据", 14, Colors.black)),
                        xtText("过期数据保存3个月，结束保存N个月", 12, main99GrayColor),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            Toast.showToast(msg: "更多历史数据");
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12),
                            child: Row(
                              children: <Widget>[
                                xtText("更多", 12, main99GrayColor),
                                Container(
                                    width: 12,
                                    height: 12,
                                    child: Image.asset(R.imagesLiveLiveStationArrowRight)
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  final model = liveHistory[index - livePlan.length - 2];
                  return obtainLiveStationCell(model);
                }
              }
            }));
  }

  //顶部背景图片
  Widget obtainTopBgImage() {
    return Container(
        width: double.infinity,
        child: Image(
          image: AssetImage(R.imagesLiveLiveStationTopBg),
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
                width: 10,
                height: 8,
                child: Image.asset(R.imagesLiveLiveStationArrowDown),
                margin: EdgeInsets.only(left: 5),
              ),
              Spacer(flex: 2),
            ],
          ),
          onTap: () {
            showDialog(context: context,child: LiveAlertDialog(liveType,(index){
              if(index != liveType){
                liveType = index;
                if (liveType == 1){
                  navTitle = "喜团优选直播";
                }
                if (liveType == 2){
                  navTitle = "喜团买菜直播";
                }
                setState(() {

                });
              }
            }));
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
  Widget obtainProfileWidget(LiveStationAnchorModel model) {
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
                      placeholder: AssetImage(R.imagesEmpty),
                      image: NetworkImage(model.avatarUrl)
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: xtText(model.nickNameText, 16, whiteColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 14,
                          height: 14,
                          child: Image.asset(anchorModel.level > 0 ? R.imagesLiveLiveAnchorLevel10 : R.imagesLiveLiveAnchorLevel0)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2, right: 8),
                        child: xtText(anchorModel.level > 0 ? "星级主播" : "普通主播", 12, whiteColor),
                      ),
                      Visibility(
                          visible: model.fansNumber > 0,
                          child: xtText(
                              "${model.fansNum}粉丝", 12, whiteColor))
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
          margin: EdgeInsets.only(top: 10, bottom: 0, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: xtColor_F7F7F7,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 22,
                      height: 22,
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset(R.imagesLiveLiveNotifyHorn),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 6, right: 10),
                      child: xtText("主播分佣制度上线，成为喜团主播有钱赚啦！", 12, xtColor_E60146),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Toast.showToast(msg: "累计佣金");
                      },
                      child: Column(
                        children: <Widget>[
                          Visibility(
                              visible: totalAmount > 0,
                              child: xtText(totalAmountString, 18, mainBlackColor)
                          ),
                          Row(
                            children: <Widget>[
                              xtText("累计佣金", 12, xtColor_A8A8A8),
                              Icon(
                                Icons.chevron_right,
                                color: xtColor_A8A8A8,
                                size: 20,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: xtColor_F5F5F5,
                    ),
                    GestureDetector(
                      onTap: (){
                        Toast.showToast(msg: "待结算佣金");
                      },
                      child: Column(
                        children: <Widget>[
                          Visibility(
                              visible: unsettledAmount > 0,
                              child: xtText(unsettledAmountString, 18, mainBlackColor)
                          ),
                          Row(
                            children: <Widget>[
                              xtText("待结算佣金", 12, xtColor_A8A8A8),
                              Icon(
                                Icons.chevron_right,
                                color: xtColor_A8A8A8,
                                size: 20,
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
          ),
        )
      ],
    );
  }
}

class LiveAlertDialog extends StatefulWidget {

  final int liveType;
  final ValueChanged<int> onTap;

  LiveAlertDialog(this.liveType,this.onTap);

  @override
  _LiveAlertDialogState createState() => _LiveAlertDialogState();
}

class _LiveAlertDialogState extends State<LiveAlertDialog> {

  int type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    type = widget.liveType;
  }

  void _liveTypeClick(int currentType){
    if (widget.onTap != null) {
      if (currentType != type){
        widget.onTap(currentType);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 270,
        height: 210,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 20),
              child: xtTextWithStyle("请选择直播业务", TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap:(){
                    _liveTypeClick(1);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: 48,
                          height: 48,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Image.asset(type == 1 ?  R.imagesLiveLiveStationXituanLogoSelected : R.imagesLiveLiveStationXituanLogoNormal)
                      ),
                      xtText("喜团优选直播", 14, type == 1 ? mainRedColor : main99GrayColor)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _liveTypeClick(2);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: 48,
                          height: 48,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Image.asset(type == 2 ? R.imagesLiveLiveStationMaicaiLogoSelected : R.imagesLiveLiveStationMaicaiLogoNormal)
                      ),
                      xtText("喜团买菜直播", 14,  type == 2 ? xtColor_39B54A : main99GrayColor)
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(top: 24),
              color: xtColor_F5F5F5,),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 44,
                child: xtText("取消", 14, mainBlackColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
