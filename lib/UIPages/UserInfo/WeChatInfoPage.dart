import 'package:flutter/material.dart';
import '../../Utils/Toast.dart';
import '../../XTConfig/AppConfig/XTMethodChannelConfig.dart';
import '../../XTConfig/AppConfig/XTRouter.dart';
import '../../XTModel/UserInfoModel.dart';
import '../../XTNetWork/UserInfoRequest.dart';
import '../NormalUI/XTAppBackBar.dart';
import '../../XTConfig/Extension/StringExtension.dart';

class WeChatInfoPage extends StatefulWidget {
  @override
  _WeChatInfoPageState createState() => _WeChatInfoPageState();
}

enum WeChatInfoState {
  none,
  uploaded,
  have
}

class _WeChatInfoPageState extends State<WeChatInfoPage> {
  /// 微信号
  final TextEditingController _wechatAccountCon = TextEditingController();
  /// 页面状态
  WeChatInfoState _state = WeChatInfoState.none;
  /// 上传图片的路径
  String _wechatQrImgUrl = "";

  @override
  void initState() {
    super.initState();
    _getWechatInfo();
  }

  /// 获取用户微信信息
  void _getWechatInfo() async {
    try {
      final WechatInfoModel model = await XTUserInfoRequest.getWechatInfoReq();
      Toast.showToast(msg: model.toJson().toString());
      if (model.wechat.isNotEmpty && model.wxQr.isNotEmpty) {
        setState(() {
          _wechatAccountCon.text = model.wechat;
          _wechatQrImgUrl = model.wxQr;
          _state = WeChatInfoState.have;
        });
      } else {
        setState(() => _state = WeChatInfoState.none);
      }
    } catch (err) {
    }
  }

  /// 更新头像
  void _uploadWxCodeImg() async {
    try {
      final String result = await XTMTDChannel.invokeMethod('updateAvAtar');
      setState(() {
        _wechatQrImgUrl = result.imgUrl;
        _state = WeChatInfoState.uploaded;
      });
    } catch (e) {
      print(e.message);
    }
  }

  /// 保存微信信息
  void _saveWxInfo() async {
    if (_wechatAccountCon.text.isEmpty) {
      Toast.showToast(msg: "请输入微信号", context: context);
      return;
    }
    if (_state != WeChatInfoState.uploaded) {
      Toast.showToast(msg: "请上传微信二维码", context: context);
      return;
    }

    try {
      final bool isSuccess = await XTUserInfoRequest.saveWechatInfoReq({
        "wxQr": _wechatQrImgUrl,
        "wechat": _wechatAccountCon.text
      });
      if (isSuccess) {
        Toast.showToast(msg: "保存成功", context: context);
        setState(() => _state = WeChatInfoState.have);
      } else {
        Toast.showToast(msg: "保存失败，请重试", context: context);
      }
    } catch (err) {
      print(err);
    }
  }

  /// 前往修改信息页面
  void _gotoInfoChangePage(bool isQr) {
    if (isQr) {
      /// 修改微信二维码
      XTRouter.pushToPage(
        routerName: "wechatQrChange", 
        params: {"qrUrl": _wechatQrImgUrl},
        context: context,
      ).then((value) => {
        setState(() {
          Map result = Map<String, dynamic>.from(value);
          _wechatQrImgUrl = result["qrUrl"];
        })
      });
    } else {
      /// 修改微信号
      XTRouter.pushToPage(
        routerName: "wechatNameChange", 
        params: {"name": _wechatAccountCon.text},
        context: context,
      ).then((value) => {
        setState(() {
          Map result = Map<String, dynamic>.from(value);
          _wechatAccountCon.text = result["name"];
        })
      });
    }
  }

  /// 查看大图
  void _lookBigPic() {
    if (_wechatQrImgUrl.isEmpty) { return; }
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return WeChatInfoImgPage(imgUrl: _wechatQrImgUrl);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation, 
                curve: Curves.fastOutSlowIn
              )
            ),
            child: child,
          );
        },
      )
    );
  }

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
                    GestureDetector(
                      onTap: () {
                        if (_state == WeChatInfoState.have) {
                          _gotoInfoChangePage(false);
                        }
                      },
                      child: Container(
                        height: 55,
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("微信号", style: TextStyle(color: Colors.black, fontSize: 16)),
                            Expanded(
                              child: TextField(
                                enabled: _state != WeChatInfoState.have,
                                controller: _wechatAccountCon,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "请输入微信号",
                                  hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 16),
                                  contentPadding: EdgeInsets.only(left: 30, right: 15),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _state == WeChatInfoState.have,
                              child: Icon(Icons.keyboard_arrow_right, color: Color(0xffb9b5b5))
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1),
                    GestureDetector(
                      onTap: () {
                        if (_state == WeChatInfoState.have) {
                          _gotoInfoChangePage(true);
                        }
                      },
                      child: Container(
                        height: 120, 
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text("微信二维码", style: TextStyle(color: Colors.black, fontSize: 16))
                            ),
                            GestureDetector(
                              onTap: () {
                                switch (_state) {
                                  case WeChatInfoState.none:
                                    _uploadWxCodeImg(); 
                                    break;
                                  case WeChatInfoState.uploaded: 
                                    // Toast.showToast(msg: "查看大图", context: context);
                                    _lookBigPic();
                                    break;
                                  case WeChatInfoState.have: 
                                    _gotoInfoChangePage(true);
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                width: 120,
                                height: 120,
                                child: Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Positioned.fromRelativeRect(
                                      rect: RelativeRect.fromLTRB(0, 20, 40, 20),
                                      child: Image(
                                        image: _state == WeChatInfoState.none ? AssetImage("images/SettingImg/wx_info_upload.jpg") : NetworkImage(_wechatQrImgUrl),
                                        width: 80,
                                        height: 80,
                                      )
                                    ),
                                    Visibility(
                                      visible: _state == WeChatInfoState.uploaded,
                                      child: Positioned.fromRect(
                                        rect: Rect.fromLTWH(70, 10, 20, 20),
                                        child: FlatButton(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Icon(Icons.cancel, color: Color(0xff999999)),
                                          onPressed: () {
                                            _wechatQrImgUrl = "";
                                            setState(() => _state = WeChatInfoState.none);
                                          },
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Visibility(
                              visible: _state == WeChatInfoState.have,
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Icon(Icons.keyboard_arrow_right, color: Color(0xffb9b5b5))
                              )
                            )
                          ],
                        ),
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
                    SizedBox(height: 50),
                    Visibility(
                      visible: _state != WeChatInfoState.have,
                      child: RaisedButton(
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
                          _saveWxInfo();
                        },
                      ),
                    ),
                    SizedBox(height: 50),
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

class WeChatInfoImgPage extends StatelessWidget {

  WeChatInfoImgPage({this.imgUrl});

  /// 微信二维码照片
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Color(0x90000000),
        child: Image.network(imgUrl),
      ),
    );
  }
}