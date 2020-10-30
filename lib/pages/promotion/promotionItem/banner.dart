import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/model/promotion_model.dart';

class BannerUtil extends StatelessWidget {
  BannerUtil(this.height, this.mode, {this.layout = SwiperLayout.DEFAULT});

  final ComponentVoList mode;
  final double height;
  final SwiperLayout layout;
  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    var top = 0.0;
    var bottom = 0.0;
    Color bgcolor = whiteColor;

    if (this.mode.config.padding != null &&
        this.mode.config.padding.length == 2) {
      top = double.parse(this.mode.config.padding.first);
      bottom = double.parse(this.mode.config.padding.last);
    }
    if (this.mode.config.backgroundColor != null) {
      bgcolor = HexColor(this.mode.config.backgroundColor);
    }
    for (var i = 0; i < this.mode.data.length; i++) {
      images.add(this.mode.data[i].img);
    }
    return Container(
        color: mainRedColor,
        padding: EdgeInsets.only(top: top, bottom: bottom),
        height: height,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(
              images[index],
              fit: BoxFit.fill,
            );
          },
          itemCount: images.length,
          autoplay: true,
          autoplayDisableOnInteraction: false,
          autoplayDelay: 5000,
          layout: layout,
        ));
  }
}

class BannerOnlyUtil extends StatelessWidget {
  BannerOnlyUtil(this.mode);
  final ComponentVoList mode;
  @override
  Widget build(BuildContext context) {
    var top = 0.0;
    var bottom = 0.0;
    Color bgcolor = whiteColor;

    if (this.mode.config.padding != null &&
        this.mode.config.padding.length == 2) {
      top = double.parse(this.mode.config.padding.first);
      bottom = double.parse(this.mode.config.padding.last);
    }
    if (this.mode.config.backgroundColor != null) {
      bgcolor = HexColor(this.mode.config.backgroundColor);
    }

    return Container(
        color: bgcolor,
        padding: EdgeInsets.only(top: top, bottom: bottom),
        child: Image.network(this.mode.data.first.img,fit: BoxFit.cover,));
  }
}
