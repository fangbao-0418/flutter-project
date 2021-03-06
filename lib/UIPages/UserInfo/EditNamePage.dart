import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

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
    if (widget.name == _tname) {
      FlutterBoost.singleton.close("editPage");
    }
    try {
      final _ = await XTUserInfoRequest.updateUserInfo({"nickName": _tname});
      FlutterBoost.singleton.close("editPage");
      // vm.updateNiceName(_tname);
    } catch (err) {
      print(err);
    }
  }

  void _xtback(BuildContext context) {
    XTRouter.closePage(context: context);

    // final BoostContainerSettings settings = BoostContainer.of(context).settings;
    // FlutterBoost.singleton.close(settings.uniqueId,
    //     result: <String, dynamic>{'result': 'data from second'});
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
    // print(name + "88888888");
    // print(params);
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
