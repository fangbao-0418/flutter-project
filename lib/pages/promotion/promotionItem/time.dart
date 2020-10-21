import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:common_utils/common_utils.dart';

class PromotionTime extends StatefulWidget {
  PromotionTime(
    this.endTime,
    this.bgColor, {
    this.roundRadius = true,
    this.styleType = 1,
    this.height = 20,
    this.fontSize = 12,
  });
  final double fontSize;
  final double height;
  final String endTime;
  final bool roundRadius;
  final Color bgColor;
  final int styleType;

  @override
  _PromotionTimeState createState() => _PromotionTimeState();
}

class _PromotionTimeState extends State<PromotionTime> {
  String remainTime = "";
  MainAxisAlignment mainAligmnet;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainAligmnet = alignment();
    var endTime = DateTime.parse(widget.endTime);
    var now = DateTime.now();
    caculateTime(now, endTime);
    startCountDown(endTime);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
        _timer = null;
      }
    }
  }

  void startCountDown(time) {
    var nowTime = DateTime.now();
    var endTime = DateTime.parse(time.toString());

    // 如果剩余时间已经不足一秒，则不必计时，直接标记超时
    if (endTime.millisecondsSinceEpoch - nowTime.millisecondsSinceEpoch <
        1000) {
      setState(() {
        remainTime = '活动结束';
      });

      return;
    }

    // 重新计时的时候要把之前的清除掉
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
        _timer = null;
      }
    }

    const repeatPeriod = const Duration(milliseconds: 100);

    caculateTime(nowTime, endTime);

    _timer = Timer.periodic(repeatPeriod, (timer) {
      //到时回调
      nowTime = nowTime.add(repeatPeriod);

      if (endTime.millisecondsSinceEpoch - nowTime.millisecondsSinceEpoch <
          1000) {
        //取消定时器，避免无限回调
        timer.cancel();
        timer = null;

        setState(() {
          remainTime = '活动结束';
        });
        return;
      }
      caculateTime(nowTime, endTime);
    });
  }

  /// 计算天数、小时、分钟、秒
  void caculateTime(nowTime, endTime) {
    Duration _surplus = endTime.difference(nowTime);
    int day = (_surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (_surplus.inSeconds ~/ 3600) % 24;
    int minute = _surplus.inSeconds % 3600 ~/ 60;
    // 如果用到秒的话计算
    int second = _surplus.inSeconds % 60;
    // 如果用到秒的话计算
    int millSecond = (_surplus.inMilliseconds % 1000) ~/ 100;

    var str = ' 活动倒计时';
    if (day > 0) {
      str = str + day.toString() + '天';
    }
    if (hour > 0 || (day > 0 && hour == 0)) {
      str = str + hour.toString() + '时';
    }
    str = str +
        minute.toString() +
        '分' +
        second.toString() +
        "秒" +
        "$millSecond     ";

    setState(() {
      remainTime = str;
    });
  }

  MainAxisAlignment alignment() {
    if (widget.styleType == 1) {
      return MainAxisAlignment.end;
    } else if (widget.styleType == 2) {
      return MainAxisAlignment.center;
    } else {
      return MainAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAligmnet,
      children: <Widget>[
        Container(
          decoration: xtRoundDecoration(widget.height * 0.5,
              borderColor: clearColor,
              borderWidth: 0,
              bgcolor: Color.fromRGBO(255, 255, 255, 0.3)),
          height: widget.height,
          margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          child: xtText(remainTime, widget.fontSize, Colors.black,
              alignment: TextAlign.center),
        ),
      ],
    );
  }
}
