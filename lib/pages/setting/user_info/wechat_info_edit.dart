import 'package:flutter/material.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_channel.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';
import 'package:xtflutter/config/extension/string_extension.dart';
import 'package:xtflutter/router/router.dart';

class WeChatInfoNameChangePage extends StatefulWidget {
  static String routerName = "wechatNameChange";

  WeChatInfoNameChangePage({this.name, this.params});

  /// 路由名称
  final String name;

  /// 传过来的参数
  final Map<String, dynamic> params;
  @override
  _WeChatInfoNameChangePageState createState() =>
      _WeChatInfoNameChangePageState();
}

class _WeChatInfoNameChangePageState extends State<WeChatInfoNameChangePage> {
  /// 微信号
  final TextEditingController _wechatAccountCon = TextEditingController();

  /// 微信名称
  FocusNode _nameNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _wechatAccountCon.text = widget.params["name"];
  }

  /// 更新微信号
  void _updateName() async {
    if (_wechatAccountCon.text.isEmpty) {
      Toast.showToast(msg: "请输入微信号", context: context);
      return;
    }
    try {
      final bool isSuccess = await XTUserInfoRequest.saveWechatInfoReq({
        "wechat": _wechatAccountCon.text,
      });
      if (isSuccess) {
        Toast.showToast(msg: "更换成功");
        XTRouter.closePage(
            context: context, result: {"name": _wechatAccountCon.text});
      } else {
        Toast.showToast(msg: "更换失败，请重试", context: context);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtbackAndRightBar(
          back: () => XTRouter.closePage(context: context),
          title: "修改微信号",
          rightTitle: "完成",
          rightFun: () => _updateName()),
      body: GestureDetector(
        onTap: () => _nameNode.unfocus(),
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(height: 1, color: Color(0xFFF9F9F9)),
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: TextField(
                        focusNode: _nameNode,
                        autofocus: true,
                        controller: _wechatAccountCon,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "请输入微信号",
                          hintStyle:
                              TextStyle(color: Color(0xffb9b5b5), fontSize: 16),
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: InputBorder.none,
                        ),
                        onEditingComplete: () {
                          _updateName();
                          _nameNode.unfocus();
                        },
                      ),
                    ),
                    Container(height: 1, color: Color(0xFFF9F9F9)),
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

class WeChatInfoQrChangePage extends StatefulWidget {
  static String routerName = "wechatQrChange";

  WeChatInfoQrChangePage({this.name, this.params});

  /// 路由名称
  final String name;

  /// 传过来的参数
  final Map<String, dynamic> params;

  @override
  _WeChatInfoQrChangePageState createState() => _WeChatInfoQrChangePageState();
}

class _WeChatInfoQrChangePageState extends State<WeChatInfoQrChangePage> {
  String _qrUrl = "";

  @override
  void initState() {
    super.initState();
    _qrUrl = widget.params["qrUrl"];
  }

  /// 更新微信二维码
  void _updateQr() async {
    try {
      final String result = await XTMTDChannel.invokeMethod('updateAvAtar');
      _qrUrl = result.imgUrl;
      _saveWxInfo();
    } catch (e) {
      print(e.message);
    }
  }

  /// 更换微信二维码
  void _saveWxInfo() async {
    try {
      final bool isSuccess = await XTUserInfoRequest.saveWechatInfoReq({
        "wxQr": _qrUrl,
      });
      if (isSuccess) {
        Toast.showToast(msg: "更换成功", context: context).then(() {
          XTRouter.closePage(context: context, result: {"qrUrl": _qrUrl});
        });
      } else {
        Toast.showToast(msg: "更换失败，请重试", context: context);
      }
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: "微信二维码", back: () => XTRouter.closePage(context: context)),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width - 80,
                    margin: EdgeInsets.only(left: 40, top: 60, right: 40),
                    child: Image(image: NetworkImage(_qrUrl)),
                  ),
                  SizedBox(height: 40),
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                            width: 0.5,
                            color: main99GrayColor,
                            style: BorderStyle.solid)),
                    onPressed: () {
                      _updateQr();
                    },
                    child: Text("更换二维码",
                        style: TextStyle(color: main66GrayColor, fontSize: 15)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
