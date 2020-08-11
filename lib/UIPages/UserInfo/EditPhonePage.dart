import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';

Widget Label (String data) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(data, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)))
  );
}

FocusNode focusNode1 = new FocusNode();
FocusNode focusNode2 = new FocusNode();

class EditPhonePage extends StatefulWidget {
  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> with WidgetsBindingObserver {
  bool showButton = true;
  @override
  void initState () {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void didChangeMetrics () {
    super.didChangeMetrics();
    print('didChangeMetrics');
    WidgetsBinding.instance.addPostFrameCallback((cb) {
      setState(() {
        showButton = MediaQuery.of(context).viewInsets.bottom == 0;
      });
    });
  }
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title: "修改手机号"),
      body: Stack(
        // color: Color.fromRGBO(0, 0, 0, .8),
        alignment:Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 80, left: 40, right: 40),
            child: Wrap(children: <Widget>[
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Image(
                    image: AssetImage("images/edit-phone-icon.png"),
                    width: 60.0,
                  )
                ),
                Text('手机信息', style: TextStyle(fontSize: 16),)
              ],),
              Container(
                margin: EdgeInsets.only(top: 102),
                child: Label('手机号码'),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Color(0xFFDDDDDD)),
                  ),
                ),
                child: TextField(
                  focusNode: focusNode1,
                  onTap: () {
                    setState(() {
                      showButton = false;
                    });
                  },
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                    hintText: '请输入手机号',
                    counterText: '',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Label('验证码'),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Color(0xFFDDDDDD)),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:  TextField(
                        focusNode: focusNode2,
                        onTap: () {
                          setState(() {
                            showButton = false;
                          });
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          hintText: '请输入手机验证码',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16)
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 12,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      color: Color(0xFFDDDDDD)
                    ),
                    Text('发送验证码', style: TextStyle(color: Color.fromRGBO(141, 141, 141, 1), fontSize: 16))
                  ],
                ),
              )
            ]),
          ),
          Positioned(
            bottom: 20,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 0),
              opacity: showButton ? 1 : 0,
              child: RaisedButton(
                padding: EdgeInsets.only(left: 40, right: 40),
                color: Color(0xFFE60113),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                onPressed: () {
                  //
                },
                child: Text("确认修改", style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 13)),
              )
            )
          )
        ]
      ),
    );
  }
  @override
  void dispose () {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}