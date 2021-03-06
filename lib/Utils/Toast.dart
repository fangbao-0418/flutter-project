import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as FT;
import 'package:xtflutter/Utils/Global.dart';

class Toast {
  FT.FToast fToast;
  BuildContext context;
  num duration;
  Widget toast(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xFF333333),
      ),
      child: Wrap(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            msg,
            style: TextStyle(color: Colors.white),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Toast.showToast({@required String msg, this.context, this.duration = 2}) {
    Toast.cancel();
    fToast = FT.FToast(context ?? Global.context);
    fToast.showToast(
      child: toast(msg),
      gravity: FT.ToastGravity.CENTER,
      toastDuration: Duration(seconds: duration),
    );
  }

  then(Function cb) {
    Future.delayed(new Duration(seconds: duration), () {
      cb();
    });
    return this;
  }

  cancel() {
    fToast.removeCustomToast();
  }

  cancelAll() {
    fToast.removeQueuedCustomToasts();
  }

  Toast.cancel() {
    FT.FToast(context ?? Global.context).removeCustomToast();
  }

  Toast.cancelAll() {
    FT.FToast(context ?? Global.context).removeQueuedCustomToasts();
  }
}
