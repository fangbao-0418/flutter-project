import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/message_model.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';

// 消息详情页，也是列表页
// create by yuanl at 2020/09/19
class MessageDetailPage extends StatefulWidget {
  static final String routeName = "/message/detail";

  final Map<String, dynamic> params;

  final String pageName;

  MessageBriefModel model;

  MessageDetailPage({this.pageName, this.params, Key key}) : super(key: key) {
    model = MessageBriefModel.fromJson(params);
  }

  @override
  _MessageDetailState createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
        title: widget.model.groupName,
        back: () {
          XTRouter.closePage(context: context);
        },
      ),
      body: Center(
        child: xtText(
          "暂无消息~",
          16,
          xtColor_969696,
        ),
      ),
    );
  }
}
