import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../NormalUI/XTAppBackBar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'dart:math';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

void _xtback(BuildContext context) {
  final BoostContainerSettings settings = BoostContainer.of(context).settings;
  FlutterBoost.singleton.close(settings.uniqueId, result: <String, dynamic>{'result': 'data from second'});
}

class _AddAddressPageState extends State<AddAddressPage> {
  /// 收货人
  final receiveTextCon = TextEditingController();
  /// 手机号
  final phoneTextCon = TextEditingController();
  /// 地区
  final addressTextCon = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title: "添加地址", back: () => _xtback(context)),
      body: Container(
          color: Colors.white,
          child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(height: 10, color: Color(0xFFF9F9F9)),
                  receiverAndPhoneView(true),
                  Container(height: 1.5, color: Color(0xFFF9F9F9), margin: EdgeInsets.only(left: 15, right: 15)),
                  receiverAndPhoneView(false),
                  Container(height: 10, color: Color(0xFFF9F9F9)),
                  addressView(),
                  Container(height: 10, color: Color(0xFFF9F9F9)),
                  selectAction(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget receiverAndPhoneView(bool isReveive) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(isReveive ? "收货人：" : "手机号：", style: TextStyle(color: Colors.black, fontSize: 14)),
          Expanded(
            child: TextField(
              controller: receiveTextCon,
              decoration: InputDecoration(
                hintText: isReveive ? "请填写收货人" : "请填写手机号",
                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 14),
                contentPadding: EdgeInsets.only(left: 15, right: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressView() {
    return Container(
      height: 150,
      padding: EdgeInsets.only(left: 15),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("选择地区", style: TextStyle(color: Colors.black, fontSize: 14)),
                Icon(Icons.keyboard_arrow_right, color: Color(0xffb9b5b5),)
              ],
            ),
          ),
          Container(height: 1.5, color: Color(0xFFF9F9F9), margin: EdgeInsets.only(left: 15, right: 15)),
          Expanded(
            child: TextField(
              controller: addressTextCon,
              maxLines: 5,
              inputFormatters: [
                LengthLimitingTextInputFormatter(40)
              ],
              decoration: InputDecoration(
                hintText: "请填写详细地址（比如街道、小区、乡镇、村）",
                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 14),
                contentPadding: EdgeInsets.only(right: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectAction() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Checkbox(value: null, onChanged: null)
        ]
      ),
    );
  }
}

















class SliverListDemo extends StatelessWidget {
  const SliverListDemo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.people),
            title: Text("联系人$index"),
          );
        },
        childCount: 2
      )
    );
  }
}