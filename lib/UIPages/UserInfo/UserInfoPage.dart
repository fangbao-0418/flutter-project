import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtflutter/ProviderVM/UserInfoVM.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTMethodChannelConfig.dart';
import 'package:xtflutter/XTConfig/Extension/StringExtension.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

import '../../XTConfig/AppConfig/XTColorConfig.dart';
import 'package:flutter_boost/flutter_boost.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  Future<dynamic> _updateHeader(UserInfoVM vm) async {
    try {
      final String result = await XTMTDChannel.invokeMethod('updateHeader');
      final rsl = await XTUserInfoRequest.updateUserInfo({"headImage": result});
      if (rsl == true) {
        vm.updateHeader(result.imgUrl);
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> _updateRealName() async {
    try {
      final bool result = await XTMTDChannel.invokeMethod('updateRealName');
    } catch (e) {
      print(e.message);
    }
  }

  final userTextStyle = TextStyle(color: mainGrayColor, fontSize: 14);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoVM>(builder: (ctx, userInfo, child) {
      return FutureBuilder(
          future: XTUserInfoRequest.getUserInfoData(),
          builder: (ctx, snapshot) {
            print("FutureBuilder --------start");
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.error != null)
              return Center(
                child: Text("请求失败"),
              );
            userInfo.updateUser(snapshot.data);
            print(snapshot.data);
            return Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          FlutterBoost.singleton.close("info");
                        }),
                    title: Text("个人信息")),
                body: Card(
                  margin: EdgeInsets.all(10),
                  child: userItem(userInfo),
                ));
          });
    });
  }

  Widget userItem(UserInfoVM userInfo) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (ctx, index) {
        switch (index) {
          case 0:
            return GestureDetector(
              onTap: () => _updateHeader(userInfo),
              child: Container(
                  height: 80, 
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: basicContent(
                    context,
                    "头像",
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: NetworkImage(userInfo.user.headImage),
                          )),
                    ),
                    false,
                  )),
            );
            break;
          case 1:
            return GestureDetector(
                onTap: () {
                  FlutterBoost.singleton
                      .open('editPage', urlParams: <String, dynamic>{
                    'nickName': userInfo.user.nickName,
                  }).then((Map<dynamic, dynamic> value) {
                    print(
                        'editName  finished. did recieve second route result $value');
                  });
                },
                child: Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: basicContent(
                        context,
                        "昵称",
                        Text(userInfo.user.nickName, style: userTextStyle),
                        false)));
            break;
          case 2:
            return GestureDetector(
                onTap: () {},
                child: Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: basicContent(
                        context,
                        "手机号",
                        Text(userInfo.user.phone, style: userTextStyle),
                        false)));
            break;
          case 3:
            return GestureDetector(
                onTap: () {
                  if (userInfo.user.userName == null) {
                    _updateRealName();
                  }
                },
                child: Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: basicContent(
                        context,
                        "真实姓名",
                        Text(
                            userInfo.user.userName == null
                                ? "未认证"
                                : userInfo.user.userName,
                            style: userTextStyle),
                        true)));
            break;
          case 4:
            return GestureDetector(
                onTap: () {
                  if (userInfo.user.userName == null) {
                    _updateRealName();
                  }
                },
                child: Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: basicContent(
                        context,
                        "身份证号",
                        Text(
                            (userInfo.user.idCard == null ||
                                    userInfo.user.idCard == "")
                                ? "未认证"
                                : userInfo.user.idCard,
                            style: userTextStyle),
                        true)));
            break;
          default:
        }
      },
    );
  }

// Image.network(imageHeader),
  Widget basicContent(
      BuildContext context, String name, Widget childWidget, bool haveArrow) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child:
              Text(name, style: TextStyle(color: mainBlackColor, fontSize: 18)),
        ),
        Expanded(
          flex: 1,
          child: Container(color: Colors.white, height: 60),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: <Widget>[
              childWidget,
              new Offstage(
                offstage: haveArrow,
                child: new Icon(Icons.arrow_right,
                    color: mainGrayColor, size: 20.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
