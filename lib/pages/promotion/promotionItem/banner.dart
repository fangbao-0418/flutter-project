import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BannerUtil extends StatelessWidget {
  BannerUtil(this.height, this.top, this.bottom, this.images,
      {this.layout = SwiperLayout.DEFAULT});
  final double top;
  final double height;
  final double bottom;
  final List images;
  final SwiperLayout layout;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: top, bottom: bottom),
        height: height,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(
              images.first,
              fit: BoxFit.fill,
            );
          },
          itemCount: images.length,
          // itemWidth: 300.0,
          // itemHeight: 300.0,
          autoplay: true,
          autoplayDisableOnInteraction: false,
          autoplayDelay: 2000,
          layout: layout,
        ));
  }
}

class BannerOnlyUtil extends StatelessWidget {
  BannerOnlyUtil(this.imageurl, this.top, this.bottom);
  final double top;
  final double bottom;
  final String imageurl;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: top, bottom: bottom),
        child: Image.network(imageurl));
  }
}
