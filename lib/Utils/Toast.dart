import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as FT;
import 'package:xtflutter/Utils/Global.dart';

class Toast {
  FT.FToast fToast;
  num duration;
  Widget toast(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xFF333333),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            msg,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Toast.showToast(
      {@required String msg, BuildContext context, this.duration = 2}) {
    fToast = FT.FToast(Global.context);
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
    if (fToast != null) {
      fToast.removeCustomToast();
    } else {
      FT.FToast(Global.context).removeCustomToast();
    }
  }

  Toast.cancelAll() {
    if (fToast != null) {
      fToast.removeQueuedCustomToasts();
    } else {
      FT.FToast(Global.context).removeQueuedCustomToasts();
    }
  }
}
