import 'package:flutter/material.dart';
import 'package:xtflutter/pages/normal/custom_error.dart';
import 'package:xtflutter/utils/global.dart';
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
    try {
      return Container(child: child);
    } catch (e) {
      return Container(child: CustomErrorWidget());
    }
  }

  @override
  void dispose() {
    Loading.forceHide();
    super.dispose();
  }
}
