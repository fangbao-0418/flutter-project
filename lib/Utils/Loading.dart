import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xtflutter/utils/global.dart';
import 'package:xtflutter/xt_config/app_config/appconfig.dart';

class SpinKitCircle extends StatefulWidget {
  const SpinKitCircle({
    Key key,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 2000),
  })  : assert(size != null),
        super(key: key);
  final double size;
  final Duration duration;

  @override
  _SpinKitCircleState createState() => _SpinKitCircleState();
}

class _SpinKitCircleState extends State<SpinKitCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    animation = new Tween(begin: 0.0, end: 11.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0,
          .6,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: List.generate(12, (index) {
            final _position = widget.size * .5;
            return Positioned.fill(
              left: _position,
              top: _position,
              child: Transform(
                transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox.fromSize(
                    size: Size.square(8),
                    child: AnimatedBuilder(
                      builder: (_, i) {
                        return _itemBuilder(index);
                      },
                      animation: _controller,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    double o = index - animation.value;
    // print(o);
    if (o <= 0) {
      o = 11 - (o).abs();
    }
    o = (o + 1) * 5 / 100;
    // print(index);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Color.fromRGBO(0, 0, 0, o),
      ),
    );
  }
}

class Loading {
  BuildContext context;
  bool showShade = false;
  static OverlayEntry newEntry;
  static num counter = 0;
  Widget get widget => Stack(children: [
        Positioned(
            top: AppConfig.navH,
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
                color: showShade ? Colors.white : Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Transform(
                        transform: Matrix4.identity()..rotateZ(-pi / 12 * 7),
                        alignment: Alignment.center,
                        child: SpinKitCircle()),
                    // Padding(
                    //     padding: EdgeInsets.only(top: 80),
                    //     child: Text('加载中...',
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           // decoration: TextDecoration.none,
                    //           color: Color(0xFF999999),
                    //         )))
                  ],
                )
                // Center(child: ),
                ))
      ]);
  Loading.show({this.context, this.showShade = false}) {
    counter++;
    if (newEntry == null) {
      newEntry = OverlayEntry(builder: (context) {
        return widget;
      });
      new Timer(new Duration(microseconds: 1), () {
        Overlay.of(context ?? Global.context).insert(newEntry);
      });
    }
  }

  Loading.hide() {
    counter--;
    if (counter <= 0) {
      counter = 0;
      newEntry?.remove();
      newEntry = null;
    }
  }

  Loading.forceHide() {
    counter = 0;
    newEntry?.remove();
    newEntry = null;
  }
}
