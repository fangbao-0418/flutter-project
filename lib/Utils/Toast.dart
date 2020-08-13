import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as FT;

class Toast {
  FT.FToast fToast;
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
      {@required String msg,
      @required BuildContext context,
      num duration = 2}) {
    fToast = FT.FToast(context);
    fToast.showToast(
      child: toast(msg),
      gravity: FT.ToastGravity.CENTER,
      toastDuration: Duration(seconds: duration),
    );
  }

  cancel() {
    fToast.removeCustomToast();
  }

  calcelAll() {
    fToast.removeQueuedCustomToasts();
  }
}
