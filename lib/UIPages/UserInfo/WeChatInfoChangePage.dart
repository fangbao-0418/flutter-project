import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/Utils/Loading.dart';
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/XTConfig/AppConfig/AppConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';
import '../../XTConfig/Extension/StringExtension.dart';

class WeChatInfoNameChangePage extends StatefulWidget {
  WeChatInfoNameChangePage({
    this.name,
    this.params,
  });

  ///传过来的参数
  final Map<String, dynamic> params;

  ///路由名字
  final String name;
  @override
  _WeChatInfoNameChangePageState createState() =>
      _WeChatInfoNameChangePageState();
}

//更新用户头像
class _WeChatInfoNameChangePageState extends State<WeChatInfoNameChangePage> {
  String _tname = "";
  final FocusNode _commentFocus = FocusNode();
  final TextEditingController editing = TextEditingController();
  bool isOnFocus = true;

  /// 更新微信号
  void _updateName() async {
    if (editing.text.isEmpty) {
      Toast.showToast(msg: "请输入微信号", context: context);
      return;
    }
    try {
      final bool isSuccess = await XTUserInfoRequest.saveWechatInfoReq({
        "wechat": editing.text,
      });
      if (isSuccess) {
        Toast.showToast(msg: "更换成功");
        XTRouter.closePage(context: context, result: {"name": editing.text});
      } else {
        Toast.showToast(msg: "更换失败，请重试", context: context);
      }
    } catch (err) {
      print(err);
    }
  }

  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);
  }

  @override
  void dispose() {
    editing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.params["nickName"];
    _tname = name;
    editing.text = _tname;

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print(_tname);
          if (isOnFocus) {
            return;
          }
          _commentFocus.unfocus();
          // setState(() {
          editing.text = _tname;
          isOnFocus = false;
          // });
        },
        child: Scaffold(
          backgroundColor: mainF5GrayColor,
          body: Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: TextField(
              focusNode: _commentFocus,
              controller: editing,
              enableInteractiveSelection: true,
              autofocus: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: "请输入微信号",
                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 16),
                contentPadding: EdgeInsets.only(left: 15, right: 15),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mainF5GrayColor,
                    width: 2,
                  ),
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(0)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mainF5GrayColor,
                    width: 2,
                  ),
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(0)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mainF5GrayColor,
                    width: 2,
                  ),
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(0)),
                ),
                suffixIconConstraints:
                    BoxConstraints(minHeight: 15, minWidth: 15),
                suffixIcon: isOnFocus
                    ? Container(
                        width: 10,
                        height: 10,
                        // color: main99GrayColor,
                        decoration: BoxDecoration(
                          color: main99GrayColor,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.close,
                              size: 10,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print(" clear -- clear ");
                              editing.clear();
                              _tname = "";
                              editing.text = _tname;
                            }),
                      )
                    : Text(""),
              ),
              onChanged: (String change) {
                print(_tname + '1');
                _tname = change;
                print(_tname + '12');
              },
              onTap: () {
                isOnFocus = true;
                editing.selection = TextSelection.fromPosition(
                    TextPosition(offset: _tname.length));
                print(editing.selection.toString() + 'selection');
                // });
              },
              onEditingComplete: () {
                print("结束编辑");
              },
            ),
          ),
          appBar: xtbackAndRightBar(
              back: () => _xtback(context),
              title: "修改信息",
              rightTitle: "完成",
              rightFun: () => _updateName()),
        ));
  }
}

class WeChatInfoQrChangePage extends StatefulWidget {
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
