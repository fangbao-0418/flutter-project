import 'package:flutter/material.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:provider/provider.dart';

import '../Utils/Toast.dart';
import '../XTModel/UserInfoModel.dart';


// //返回
//   void _xtback(BuildContext context) {
//     // final BoostContainerSettings settings = BoostContainer.of(context).settings;

//     // FlutterBoost.singleton.close(settings.uniqueId,
//     // result: <String, dynamic>{'result': 'data from second'});
//   }

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          back: () {
            XTRouter.closePage(context: context);
          },
          title: "设置"),
      body: Column(
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(10),
              shadowColor: whiteColor,
              child: listTab(context)),
        ],
      ),
    );
  }

  Widget listTab(context) {

      final usermodel = Provider.of<UserInfoVM>(context);

       
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        basicContent("个人信息", tapFunc: () {
          print("1233444");
          // Global.context = context;
          XTRouter.pushToPage(context: context, routerName: "info");
        }),
        basicContent("全球淘付款人实名信息", tapFunc: () {
          XTRouter.pushToPage(context: context, routerName: "page1");
        }),
        basicContent("收货地址", tapFunc: () {
          /// 测试数据 待地址列表完成后即可删除
          Map<String, dynamic> params = {
            "address": "安徽省 安庆市 太湖县 仓前街道五迪中心A2幢4楼喜团科技",
            "city": "安庆市",
            "cityId": 340800,
            "consignee": "朋学良",
            "defaultAddress": 1,
            "district": "太湖县",
            "districtId": 340825,
            "freight": 0,
            "id": 65573,
            "memberId": 7838383,
            "phone": "18365295533",
            "province": "安徽省",
            "provinceId": 340000,
            "street": "仓前街道五迪中心A2幢4楼喜团科技"
          };
          AddressListModel model = AddressListModel.fromJson(params);
          XTRouter.pushToPage(
            routerName: "addAddress", 
            params: model.toJson(),
            context: context,
          );
        }),
        basicContent("支付宝账号", tapFunc: () {
          // XTRouter.pushToPage(routerName: "editPhone", context: context);
          XTRouter.pushToPage(
            routerName: "addAddress", 
            context: context,
          ).then((value) {
            print("addAddressaddAddress == ${value.toString()}");
          });
        }),
        basicContent("消息通知", tapFunc: () {
          XTRouter.pushToPage(
              context: context,
              routerName: makeRouter(true, null, "gotoNotice"));
        }),
        basicContent("微信信息", tapFunc: () {
          XTRouter.pushToPage(
              context: context,
              routerName: makeRouter(true, null, "gotoNotice"));
        }),
        basicContent("关于喜团",
            childStr: "v" + AppConfig.getInstance().appVersion,
            haveLine: false, tapFunc: () {
          XTRouter.pushToPage(
              context: context,
              routerName: makeRouter(true, null, "aboutXiTuan"));
        })
      ],
    );
  }

  Widget line(bool hascolor) {
    return Container(
      height: 1.0,
      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
      color: hascolor ? mainF5GrayColor : Colors.white,
    );
  }

  Widget basicContent(
    String name, {
    GestureTapCallback tapFunc,
    bool haveLine = true,
    String childStr = "",
  }) {
    return GestureDetector(
        onTap: tapFunc,
        child: Column(
          children: <Widget>[
            Row(
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(name,
                          style:
                              TextStyle(color: mainBlackColor, fontSize: 16))),
                ),
                Expanded(
                  flex: 1,
                  child: Container(color: Colors.white, height: 45),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Text(childStr),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(Icons.keyboard_arrow_right,
                            color: main99GrayColor, size: 22.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
            line(haveLine),
          ],
        ));
  }
}
