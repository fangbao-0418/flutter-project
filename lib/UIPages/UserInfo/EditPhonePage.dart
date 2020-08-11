import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';

class EditPhonePage extends StatefulWidget {
  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

Widget Label (String data) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(data, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)))
  );
}

FocusNode focusNode = new FocusNode();

class _EditPhonePageState extends State<EditPhonePage> {
  bool showButton = true;
  initState () {
    super.initState();
    focusNode.addListener((){
      print(focusNode.hasFocus);
      setState(() {
        showButton = !focusNode.hasFocus;
      });
    });
  }
  dispose () {
    // focusNode
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
                  // focusNode: focusNode,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                    hintText: '请输入手机号',
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
                        // focusNode: focusNode,
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
            child: Align(
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
}