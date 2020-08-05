import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

void main() => runApp(XTApp());

class XTApp extends StatefulWidget {
  @override
  _XTAppState createState() => _XTAppState();
}

class _XTAppState extends State<XTApp> {

  @override
  void initState() {
    FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder> {
      "userInfo": (String pageName, Map<String, dynamic> params, String uniqueId) => UserInfo(),
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.white,
          accentColor: Colors.green,
          primaryColorBrightness: Brightness.light,
      ),
      home: MyHomePage(title: '喜团'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
    
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '喜团',
            ) 
          ],
        ),
      ),
    );
  }
}
