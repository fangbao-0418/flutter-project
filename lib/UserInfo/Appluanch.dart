import 'package:flutter/material.dart';
import 'UserInfo.dart';
class XTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: "个人信息",
     routes: {
       "userinfo":(BuildContext context) =>UserInfo(),
     },
     home: UserInfo(),
   );
  }
}
