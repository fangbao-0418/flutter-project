import 'package:flutter/material.dart';
import '../XTMethodCongfig/XTMethodChannelConfig.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;


  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
   
    XTMethodCnl.invokeMethod("method",["1",'2']);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

