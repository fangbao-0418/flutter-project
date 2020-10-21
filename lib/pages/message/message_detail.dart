import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/date_utils.dart';
import 'package:xtflutter/Utils/string_utils.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/message_model.dart';
import 'package:xtflutter/net_work/message_request.dart';
import 'package:xtflutter/pages/message/message_center.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/widget/scrollview/scroll_behaviors.dart';

// 消息详情页，也是列表页
// create by yuanl at 2020/09/19
class MessageDetailPage extends StatefulWidget {
  static final String routerName = "/message/detail";

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
  Future<List<MessageListDetailModel>> _future;

  _fetchList() {
    _future = MessageRequest.getMessageDetailList(widget.model.group);
  }

  @override
  void initState() {
    super.initState();
    _fetchList();
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
        body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data.length > 0) {
              return ScrollConfiguration(
                behavior: DefaultBehavior(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => _buildItem(
                      context,
                      snapshot.data[index] as MessageListDetailModel,
                      index),
                  itemCount: snapshot.data.length,
                ),
              );
            } else {
              return MessageCenterPage.emptyWidget(context);
            }
          },
          future: _future,
        ));
  }

  Widget _buildItem(
      BuildContext context, MessageListDetailModel model, int index) {
    var hasLink = StringUtils.isNotEmpty(model.jumpUrl);
    return GestureDetector(
      onTap: () {
        if (hasLink) {
          XTRouter.pushToPage(
            routerName: model.jumpUrl,
            context: context,
            isNativePage: true,
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  xtTextWithStyle(
                    model.title,
                    TextStyle(
                      color: mainBlackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                    alignment: TextAlign.start,
                  ),
                  Spacer(),
                  xtTextWithStyle(
                    DateUtils.formatMs(model.time),
                    TextStyle(
                      color: mainA8GrayColor,
                      fontSize: 11.0,
                    ),
                    alignment: TextAlign.end,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: xtTextWithStyle(
                  model.content,
                  TextStyle(
                    color: mainBlackColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w200,
                  ),
                  alignment: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: hasLink ? 10 : 0),
                height: hasLink ? 1 : 0,
                color: xtColor_FFF3F3F3,
              ),
              _bottomWidget(context, hasLink),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomWidget(BuildContext context, bool hasLink) {
    return hasLink
        ? Row(
            children: <Widget>[
              xtTextWithStyle(
                "查看详情",
                TextStyle(
                  color: xtColor_4D88FF,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                ),
                alignment: TextAlign.start,
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_right,
                size: 20.0,
                color: mainA8GrayColor,
              )
            ],
          )
        : Container();
  }
}
