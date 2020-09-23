import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/pages/setting/user_info/add_address.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xtflutter/utils/event_bus.dart';

class AddressListPage extends StatefulWidget {
  static String routerName = "addressList";

  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId,
        result: <String, dynamic>{'result': 'data from second'});
  }

  List<AddressListModel> addressModels;
  Future future;

  Future refresh() async {
    return future = XTUserInfoRequest.obtainAddressList();
  }

  @override
  initState() {
    super.initState();
    future = XTUserInfoRequest.obtainAddressList();
    bus.on(AddAddressPage.busEventName, (arg) {
      refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(AddAddressPage.busEventName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: xtBackBar(title: "我的收货地址", back: () => _xtback(context)),
      body: FutureBuilder(
          future: refresh(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            if (snapShot.hasData) {
              addressModels = snapShot.data;
              if (addressModels.length == 0) {
                return emptyViewAdd();
              }
              return buildAddressListView(addressModels);
            } else {
              return emptyViewAdd();
            }
          }),
    );
  }

  ///获取新增收货地址Button
  Widget buildAddNewAddressButton() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 50),
      child: FlatButton(
          padding: EdgeInsets.only(left: 45, right: 45, top: 10, bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.red,
          onPressed: () {
            XTRouter.pushToPage(
              routerName: AddAddressPage.routerName,
              context: context,
            );
          },
          child:xtText("新增收货地址", 15, whiteColor)
      ),
    );
  }

  ///获取复选框组件
  Widget buildCheckBox(AddressListModel model, bool isSelected) {
    return IconButton(
        icon: Icon(
          model.defaultAddress == 1
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: model.defaultAddress == 1 ? mainRedColor : main99GrayColor,
          size: 20,
        ),
        onPressed: () {
          if (model.defaultAddress == 1) {
            return;
          }
          XTUserInfoRequest.setDefaultAddress(model.id).then((value) {
            // Toast.showToast(msg: '设置默认地址成功');
            // print("地址ID：" + model.id.toString() + "状态:" + value.toString());
            //改变_CheckBoxState
            setState(() {});
          });
        });
  }

  /// 获取ListViewCell
  Widget buildAddressListCell(AddressListModel model) {
    return Container(
      color: whiteColor,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: xtText(model.consignee, 14, Colors.black),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: xtText(model.phone, 14, Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 16.0, top: 10, bottom: 15, right: 16),
                child: xtText(model.address, 12, xtColor_8C8C8C,overflow: TextOverflow.ellipsis),
              ),
              Spacer()
            ],
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: xtColor_EEEEEE,
          ),
          Row(
            children: <Widget>[
              buildCheckBox(model, model.defaultAddress == 1),
              xtText("默认地址", 14, Colors.black),
              Spacer(),

              GestureDetector(
                onTap: () {
                  XTRouter.pushToPage(
                    routerName: AddAddressPage.routerName,
                    params: model.toJson(),
                    context: context,
                  );
                },
                child: Container(
                  color: whiteColor,
                  margin: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 14,
                          height: 14,
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset("images/my_address_list_edit.png")
                      ),
                      xtText("编辑", 14, Colors.black)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSlideAddressCell(AddressListModel model) {
    return Slidable(
      child: buildAddressListCell(model),
      actionPane: SlidableScrollActionPane(),
      secondaryActions: <Widget>[
        SlideAction(
          color: Colors.red,
          child: xtText("删除", 14, whiteColor),
          onTap: () {
            XTUserInfoRequest.deleteAddress(model.id).then((value) {
              setState(() {});
            });
          },
        )
      ],
    );
  }

  Widget emptyViewAdd() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
          child: Container(
            color: xtColor_F9F9F9,
          ),
        ),
        Center(
          child: Container(
              margin: EdgeInsets.only(top: 200),
              child: xtText("还没有收货地址，快去添加收货地址吧～", 14, xtColor_666666)
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(color: whiteColor, height: 300),
        ),
        RaisedButton(
          elevation: 0,
          padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
          color: mainRedColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                  width: 0.5, color: mainRedColor, style: BorderStyle.solid)),
          onPressed: () {
            XTRouter.pushToPage(
              routerName: AddAddressPage.routerName,
              context: context,
            );
          },
          child:xtText("新增收货地址", 15, whiteColor),
        ),
        Expanded(
          flex: 1,
          child: Container(color: whiteColor, height: 60),
        ),
      ],
    );
  }

  ///获取ListView
  Widget buildAddressListView(List<AddressListModel> models) {
    return ListView.builder(
        itemCount: models.length,
        itemBuilder: (context, index) {
          final model = models[index];
          if (index == models.length - 1) {
            return Column(children: <Widget>[
              SizedBox(
                height: 10,
                child: Container(
                  color: xtColor_F9F9F9,
                ),
              ),
              buildSlideAddressCell(model),
              SizedBox(
                height: 10,
                child: Container(
                  color: xtColor_F9F9F9,
                ),
              ),
              buildAddNewAddressButton()
            ]);
          } else {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                  child: Container(
                    color: xtColor_F9F9F9,
                  ),
                ),
                buildSlideAddressCell(model)
              ],
            );
          }
        });
  }
}
