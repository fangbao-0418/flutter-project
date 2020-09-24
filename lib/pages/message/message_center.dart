import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xtflutter/Utils/XtLogger.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/message_model.dart';
import 'package:xtflutter/net_work/message_request.dart';
import 'package:xtflutter/pages/message/message_detail.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/r.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/widget/scrollview/DefaultBehavior.dart';

// 消息中心页面
// create by yuanl at 2020/09/17
class MessageCenterPage extends StatefulWidget {
  static final String routeName = "/message/center";

  static const String title = "消息中心";

  const MessageCenterPage();

  @override
  State<StatefulWidget> createState() => _MessageCenterState();

  static emptyWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              R.imagesImgMessageEmpty,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            xtText(
              "主人，暂时没有收到任何消息哦～ ",
              13,
              AppColors.FFA8A8A8,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCenterState extends State<MessageCenterPage> {
  Future<List<MessageBriefModel>> _future;

  _MessageCenterState() {
    XtLogger.logPrint("_MessageCenterState constructor~");
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    XtLogger.logPrint("_MessageCenterState initState~");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
        title: MessageCenterPage.title,
        back: () {
          XTRouter.closePage(context: context);
        },
      ),
      body: Container(
        margin: EdgeInsets.only(top: 12),
        child: FutureBuilder<List<MessageBriefModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null && snapshot.data.length > 0) {
                  return ScrollConfiguration(
                    behavior: DefaultBehavior(),
                    child: ListView.builder(
                      itemCount: snapshot?.data?.length,
                      itemBuilder: (context, index) {
                        final model = snapshot.data[index];
                        return _MessageItemWidget(
                          model: model,
                        );
                      },
                    ),
                  );
                } else {
                  return MessageCenterPage.emptyWidget(context);
                }
              } else if (snapshot.connectionState == ConnectionState.none) {
                return MessageCenterPage.emptyWidget(context);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  _fetchData() {
    _future = MessageRequest.getMesageList();
  }
}

class _MessageItemWidget extends StatelessWidget {
  final MessageBriefModel model;

  _MessageItemWidget({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toMessageDetail(context, model);
      },
      child: Container(
        margin: EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Image.network(
              model.iconUrl,
              width: 40,
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  xtTextWithStyle(
                    model.groupName,
                    TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    alignment: TextAlign.left,
                  ),
                  Container(
                    height: 4,
                    width: 0,
                  ),
                  xtText(
                    model.title ?? "还没有消息哦",
                    11,
                    AppColors.FFA8A8A8,
                    alignment: TextAlign.left,
                  )
                ],
              ),
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_right,
              color: mainA8GrayColor,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  _toMessageDetail(BuildContext context, MessageBriefModel model) {
    XTRouter.pushToPage(
      routerName: MessageDetailPage.routeName,
      context: context,
      params: model.toJson(),
    );
  }
}
