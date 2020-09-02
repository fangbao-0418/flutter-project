import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/ui_pages/ui_normal/app_nav_bar.dart';
import 'package:xtflutter/utils/loading.dart';
import 'package:xtflutter/utils/toast.dart';
import 'package:xtflutter/xt_config/app_config/appconfig.dart';
import 'package:xtflutter/xt_config/app_config/xt_color_config.dart';
import 'package:xtflutter/xt_config/app_config/xt_router.dart';
import 'package:xtflutter/xt_net_work/userinfo_request.dart';

class EditNamePage extends StatefulWidget {
  EditNamePage({
    this.name,
    this.params,
  });

  ///传过来的参数
  final Map<String, dynamic> params;

  ///路由名字
  final String name;
  @override
  _EditNamePage createState() => _EditNamePage();
}

//更新用户头像
class _EditNamePage extends State<EditNamePage> {
  String _tname = "";
  final FocusNode _commentFocus = FocusNode();
  final TextEditingController editing = TextEditingController();
  bool isOnFocus = true;

  void _updateName() async {
    if (_tname.isEmpty) {
      Toast.showToast(msg: "请输入昵称", context: context);
      return;
    }
    if (widget.name == _tname) {
      FlutterBoost.singleton.close("editPage");
    }
    Loading.show(context: context);
    try {
      final succ = await XTUserInfoRequest.updateUserInfo({"nickName": _tname})
          .catchError((err) {
        Loading.hide();
        Toast.showToast(msg: err.message, context: context);
      });
      if (succ) {
        Loading.hide();
        AppConfig.getInstance().userVM.updateNiceName(_tname);
        Toast.showToast(msg: "修改成功", context: context).then(() {
          FlutterBoost.singleton.close("editPage");
        });
      } else {
        Loading.hide();
        Toast.showToast(msg: "修改失败，请重试", context: context);
      }
      // vm.updateNiceName(_tname);
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
