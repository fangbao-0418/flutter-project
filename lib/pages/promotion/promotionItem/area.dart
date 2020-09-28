import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/promotion_model.dart';

class AreaAttach extends StatefulWidget {
  AreaAttach(this.model);

  final ComponentVoList model;
  @override
  _AreaAttachState createState() => _AreaAttachState();
}

class _AreaAttachState extends State<AreaAttach> {
  ///图片宽度
  int imgW = 0;

  ///图片高度

  int imgH = 0;

  ///缩放比例

  double scale = 1.0;

  ///屋里宽度
  final double width =
      ui.window.physicalSize.width / ui.window.devicePixelRatio;

  List<Widget> positionList(Image image) {
    List<Widget> positions = [image];

    for (var i = 0; i < widget.model.data.first.area.length; i++) {
      Area arinfo = widget.model.data.first.area[i];
      List<String> areaPoint = arinfo.coordinate.split(",");
      print(areaPoint.toString());
      double a1 = double.parse(areaPoint.first);
      double a2 = double.parse(areaPoint[1]);
      double a3 = double.parse(areaPoint[2]);
      double a4 = double.parse(areaPoint[3]);
      double x = width * a1;
      double y = imgH / imgW * width * a2;
      double ww = width * a3;
      double hh = imgH / imgW * width * a4;
      print(a1.toString());
      print(a2.toString());
      print(a3.toString());
      print(a4.toString());
      print("object-----------Stack");

      print(x.toString());
      print(y.toString());
      print(ww.toString());
      print(hh.toString());

      var pos = Positioned(
          left: x,
          top: y,
          child: GestureDetector(
            onTap: () {
              print("object-----------Stack");
              print(arinfo.value);
            },
            child: Container(
              width: ww,
              height: hh,
              color: clearColor,
            ),
          ));
      positions.add(pos);
    }
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    Datum areaInfo = widget.model.data.first;
    Image image = Image.network(
      areaInfo.url,
      fit: BoxFit.fill,
      width: width,
    );
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((info, succe) {
          imgW = info.image.width;
          imgH = info.image.height;
          scale = width / imgW;
          print("info -------" + info.image.width.toString());
          print("info -------" + info.image.height.toString());
          print("info -------" + succe.toString());
        }, onChunk: (event) {}, onError: null));
    image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image.image);
    }));
    var top = 0.0;
    var bottom = 0.0;
    // Color bgcolor = whiteColor;

    if (widget.model.config.padding != null &&
        widget.model.config.padding.length == 2) {
      top = double.parse(widget.model.config.padding.first);
      bottom = double.parse(widget.model.config.padding.last);
    }
    // if (widget.model.config.backgroundColor != null) {
    //   bgcolor = HexColor(widget.model.config.backgroundColor);
    // }

    return FutureBuilder(
        future: completer.future,
        builder: (context, shot) {
          if (shot.hasData) {
            return Container(
                // color: bgcolor,
                padding: EdgeInsets.only(top: top, bottom: bottom),
                child: Stack(children: positionList(image)));
          } else {
            return Container(
              width: 100,
              height: 0,
              color: main66GrayColor,
            );
          }
        });
  }
}
