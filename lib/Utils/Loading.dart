import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Global.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_spinkit/src/tweens/delay_tween.dart';

class SpinKitCircle extends StatefulWidget {
  const SpinKitCircle({
    Key key,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
  })  : assert(size != null),
        super(key: key);
  final double size;
  final Duration duration;

  @override
  _SpinKitCircleState createState() => _SpinKitCircleState();
}

class _SpinKitCircleState extends State<SpinKitCircle>
    with SingleTickerProviderStateMixin {
  final List<double> delays = [
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1
  ];
  AnimationController _controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation = new Tween(begin: 11.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0,
          1,
          curve: Curves.ease,
        ),
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print(status);
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
        // setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(animation.value);
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: List.generate(delays.length, (index) {
            final _position = widget.size * .5;
            return Positioned.fill(
              left: _position,
              // top: _position,
              child: Transform(
                transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox.fromSize(
                    size: Size.square(widget.size * 0.15),
                    child: _itemBuilder(index),
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
    double o = (animation.value + index - 12) * 5 / 100;
    // print(_itemBuilder);
    // print(o);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(0, 0, 0, o),
      ),
    );
  }
}

class Loading {
  BuildContext context;
  static OverlayEntry newEntry;
  static num counter = 0;
  num counterState = 0;
  Loading.show({this.context}) {
    counter++;
    if (newEntry == null) {
      newEntry = OverlayEntry(builder: (context) {
        return Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // color: Colors.white,
              // child: Center(child: SpinKitCircle(size: 60)
              child: Transform(
                  transform: Matrix4.identity()..rotateZ(4.12),
                  alignment: Alignment.center,
                  child: SpinKitCircle(size: 60)),
            ));
      });
      // context.findRootAncestorStateOfType<OverlayState>().insert(newEntry);
      // (context.findRootAncestorStateOfType() as dynamic).setState(() {
      //   counterState = counter;
      // });
      Overlay.of(context ?? Global.context).insert(newEntry);
    }
  }

  Loading.hide() {
    counter--;
    if (counter <= 0) {
      counter = 0;
      print(newEntry);
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
