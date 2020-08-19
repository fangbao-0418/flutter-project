import 'package:flutter/material.dart';
import '../../XTConfig/AppConfig/XTRouter.dart';
import '../NormalUI/XTAppBackBar.dart';

class AlipayAccountPage extends StatefulWidget {
  @override
  _AlipayAccountPageState createState() => _AlipayAccountPageState();
}

class _AlipayAccountPageState extends State<AlipayAccountPage> {
  /// 收货人
  final TextEditingController accountTextCon = TextEditingController();
  /// 手机号
  final TextEditingController nameTextCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title: "支付宝", back: () => XTRouter.closePage(context: context)),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(height: 10, color: Color(0xFFF9F9F9)),
                    accountAndNameView(true),
                    Container(height: 1.5, color: Color(0xFFF9F9F9), margin: EdgeInsets.only(left: 15, right: 15)),
                    accountAndNameView(false),
                    Container(height: 10, color: Color(0xFFF9F9F9)),
                    // addressView(),
                    Container(height: 10, color: Color(0xFFF9F9F9)),
                    // selectAction(),
                    SizedBox(height: 80),
                    // saveButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget accountAndNameView(bool isAccount) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(isAccount ? "支付宝账号" : "姓名", style: TextStyle(color: Colors.black, fontSize: 14)),
          Expanded(
            child: TextField(
              controller: isAccount ? accountTextCon : nameTextCon,
              keyboardType: isAccount ? TextInputType.text : TextInputType.phone,
              decoration: InputDecoration(
                hintText: isAccount ? "请输入支付宝账号" : "请请输入真实姓名",
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
}