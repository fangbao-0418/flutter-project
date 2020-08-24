import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/Utils/Loading.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTSizeFit.dart';
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId,
        result: <String, dynamic>{'result': 'data from second'});
  }

  @override
  Widget build(BuildContext context) {
    List<AddressListModel> addressModels;
    Future future = XTUserInfoRequest.obtainAddressList();

    Future refresh() async {
      return future;
    }

    @override
    initState() {
      super.initState();
      future = XTUserInfoRequest.obtainAddressList();
    }

    ///获取新增收货地址Button
    Widget buildAddNewAddressButton() {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 98, bottom: 50),
        margin: EdgeInsets.only(top: 10),
        child: Container(
          padding: EdgeInsets.only(left: 98, right: 98),
          height: 40,
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red,
              onPressed: () {
                XTRouter.pushToPage(
                  routerName: "addAddress",
                  context: context,
                ).then((value) {
                  Map result = Map<String, dynamic>.from(value);
                  if (result["isRefresh"] == true) {
                    refresh();
                    print("新增地址成功后，地址列表刷新");
                  }
                });
              },
              child: Text(
                "新增收货地址",
                style: TextStyle(fontSize: 15, color: Colors.white),
              )),
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
            XTUserInfoRequest.setDefaultAddress(model.id).then((value) {
              print("地址ID：" + model.id.toString() + "状态:" + value.toString());
              //改变_CheckBoxState
              setState(() {});
            });
          });
    }

    /// 获取ListViewCell
    Widget buildAddressListCell(AddressListModel model) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    model.consignee,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    model.phone,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
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
                  child: Text(
                    model.address,
                    style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer()
              ],
            ),
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFEEEEEE),
            ),
            Row(
              children: <Widget>[
                buildCheckBox(model, model.defaultAddress == 1),
                Text(
                  "默认地址",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Spacer(),
                FlatButton.icon(
                    onPressed: () {
                      XTRouter.pushToPage(
                        routerName: "addAddress",
                        params: model.toJson(),
                        context: context,
                      ).then((value) {
                        Map result = Map<String, dynamic>.from(value);
                        if (result["isRefresh"] == true) {
                          refresh();
                          print("修改地址成功后，地址列表刷新");
                        }
                      });
                    },
                    icon: ImageIcon(
                      AssetImage('images/my_address_list_edit.png'),
                      color: Colors.black,
                    ),
                    label: Text(
                      "编辑",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ))
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
            child: Text(
              "删除",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          )
        ],
      );
    }

    ///获取ListView
    Widget buildAddressListView(List<AddressListModel> models) {
      return ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemCount: models.length,
          itemBuilder: (context, index) {
            final model = models[index];
            if (index == models.length - 1) {
              return Column(children: <Widget>[
                SizedBox(
                  height: 10,
                  child: Container(
                    color: Color(0xFFF9F9F9),
                  ),
                ),
                buildSlideAddressCell(model),
                SizedBox(
                  height: 10,
                  child: Container(
                    color: Color(0xFFF9F9F9),
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
                      color: Color(0xFFF9F9F9),
                    ),
                  ),
                  buildSlideAddressCell(model)
                ],
              );
            }
          });
    }

    Widget emptyViewAdd() {
      return Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Text("暂无地址")),
          ),
          Expanded(
            flex: 1,
            child: Container(color: Colors.white, height: 300),
          ),
          RaisedButton(
            elevation: 0,
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                    width: 0.5, color: mainRedColor, style: BorderStyle.solid)),
            onPressed: () {
              XTRouter.pushToPage(
                routerName: "addAddress",
                context: context,
              ).then((value) {
                Map result = Map<String, dynamic>.from(value);
                if (result["isRefresh"] == true) {
                  refresh();
                  print("新增地址成功后，地址列表刷新");
                }
              });
            },
            child: Text("新增地址",
                style: TextStyle(color: mainRedColor, fontSize: 14)),
          ),
          Expanded(
            flex: 1,
            child: Container(color: Colors.white, height: 60),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: xtBackBar(title: "我的收货地址", back: () => _xtback(context)),
      body: FutureBuilder(
          // ignore: missing_return
          future: refresh(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            print('data:${snapShot.data}');
            print('connectionState:${snapShot.connectionState}');
            if (snapShot.connectionState == ConnectionState.waiting) {
              Loading.show(context: context, showShade: false);
              return Text('');
            } else {
              Loading.hide();
              if (snapShot.hasData) {
                addressModels = snapShot.data;
                if (addressModels.length == 0) {
                  return emptyViewAdd();
                }
                return buildAddressListView(addressModels);
//                return Text(snapShot.data.toString());
              } else {
                return emptyViewAdd();
              }
            }
          }),
    );
  }
}
