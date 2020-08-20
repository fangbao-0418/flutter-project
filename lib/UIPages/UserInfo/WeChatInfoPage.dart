import 'package:flutter/material.dart';
import 'package:xtflutter/Widgets/DashedDecoration.dart';
import '../../XTConfig/AppConfig/XTRouter.dart';
import '../NormalUI/XTAppBackBar.dart';

class WeChatInfoPage extends StatefulWidget {
  @override
  _WeChatInfoPageState createState() => _WeChatInfoPageState();
}

class _WeChatInfoPageState extends State<WeChatInfoPage> {
  /// 微信号
  final TextEditingController wechatAccountCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title: "微信信息", back: () => XTRouter.closePage(context: context)),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            color: Color(0xFFF9F9F9),
            child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 1),
                    Container(
                      height: 55,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("微信号", style: TextStyle(color: Colors.black, fontSize: 16)),
                          Expanded(
                            child: TextField(
                              controller: wechatAccountCon,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "请输入微信号",
                                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 16),
                                contentPadding: EdgeInsets.only(left: 30, right: 15),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1),
                    Container(
                      height: 120, 
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text("微信二维码", style: TextStyle(color: Colors.black, fontSize: 16))
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            width: 80,
                            height: 80,
                            decoration: DashedDecoration(
                              dashedColor: Color(0x55969696),
                              borderRadius: BorderRadius.circular(5),
                              gap: 3,
                              dawDashed: true
                            ),

                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, top: 5), 
                      child: Text(
                        "您的微信号和二维码将展示在团队成员的页面\n方便团队成员更快的找到你哦~", 
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12, color: Color(0xff969696))
                      )
                    ),
                    // selectAction(),
                    SizedBox(height: 50),
                    RaisedButton(
                      color: Color(0xffe60113),
                      child: Text(
                        "保存",
                        style: TextStyle(color: Colors.white, fontSize: 16)
                      ),
                      padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      onPressed: () {
                        // saveAlipayAccount();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}