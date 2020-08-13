import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class XTToast {
  /// toast展示
  static show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Color(0xff333333),
      textColor: Colors.white,
      fontSize: 16
    );
  }
}


