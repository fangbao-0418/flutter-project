import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Global.dart';
class Wrapper extends StatefulWidget {
  final Widget child;
  final BuildContext routeContext;
  Wrapper({
    Key key,
    this.child,
    this.routeContext
  });
    @override
  _WrapperState createState() => _WrapperState(
    child: child,
    routeContext: routeContext
  );
}


class _WrapperState extends State<Wrapper> {
 final Widget child;
 final BuildContext routeContext;
  _WrapperState({
    Key key,
    this.child,
    this.routeContext
  });
  void initState () {
    super.initState();
    print('wrapper init');
    print(routeContext);
    print(context);
    Global.context = routeContext ?? context;
  }
  Widget build(BuildContext context) {
    print('wrapper build');
    return Container(child: child);
  }

  @override
  void dispose() {
    print('wrapper dispose');
    Global.context = context;
    super.dispose();
  }
}