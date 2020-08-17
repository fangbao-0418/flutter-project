import 'package:flutter/material.dart';
import 'package:xtflutter/Utils/Global.dart';

class Loading {
  BuildContext context;
  static OverlayEntry newEntry;
  static num counter = 0;
  Loading.show({@required this.context}) {
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
              child: Center(
                child: Image(
                    width: 100,
                    // height: 100,
                    fit: BoxFit.fitWidth,
                    image: AssetImage("images/loading.gif")),
              ),
            ));
      });
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
}
