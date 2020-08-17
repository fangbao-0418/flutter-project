import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Global.dart';
import 'package:xtflutter/Utils/Toast.dart';

class Wrapper extends StatefulWidget {
  final Widget child;
  final BuildContext routeContext;
  Wrapper({Key key, this.child, this.routeContext});
  @override
  State<StatefulWidget> createState() {
    return _WrapperState(child: child);
  }
}

class _WrapperState extends State<Wrapper> {
  final Widget child;
  final BuildContext routeContext;
  _WrapperState({Key key, this.child, this.routeContext});
  Widget build(BuildContext context) {
    return Container(child: child);
  }

  void dispose() {
    Toast.cancelAll();
    super.dispose();
  }
}
