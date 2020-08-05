import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTColorConfig.dart';

class EditNamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: mainBlackColor,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            // final BoostContainerSettings settings =
            //     BoostContainer.of(context).settings;
            // FlutterBoost.singleton.close(
            //   settings.uniqueId,
            //   result: <String, dynamic>{'result': 'edit-name'},
            // );
          },
        ),
        title: Text('导航'),
        actions: <Widget>[
          FlatButton(
            color: Colors.pink,
            textColor: Colors.white,
            child: Text('扁平按钮'),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => debugPrint('Search button is pressed'),
          ),
        ],
      ),
    );
  }
}
