import 'package:flutter/material.dart';
import 'package:xtflutter/utils/global.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/pages/normal/loading.dart';

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
  @override
  void initState() {
    super.initState();
    Global.context = context;
  }

  Widget build(BuildContext context) {
    return Container(child: child);
  }

  @override
  void dispose() {
    Loading.forceHide();
    // Toast.cancelAll();
    super.dispose();
  }
}
