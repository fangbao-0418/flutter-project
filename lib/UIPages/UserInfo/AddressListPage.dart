import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTSizeFit.dart';
import 'package:xtflutter/Utils/Toast.dart';

class AddressListPage extends StatelessWidget {
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId, result: <String, dynamic>{'result': 'data from second'});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title:"我的收货地址",back: () => _xtback(context)),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView(
          children: <Widget>[
            AddressListCell(),
            AddressListCell(),
          ],
        ),
      ),
    );
  }
}

class AddressListCell extends StatelessWidget {
  const AddressListCell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Hicks",style: TextStyle(fontSize: 14, color: Colors.black),),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text("13588724545",style: TextStyle(fontSize: 14, color: Colors.black),),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:16.0, top: 10,bottom: 15),
                child: Text("浙江省杭州市余杭区XXXXX大厦1121室", style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),),
              ),
              Spacer()
            ],
          ),
          Divider(height: 1,indent: 16,endIndent: 16,color: Color(0xFFEEEEEE),),
          Row(
            children: <Widget>[
              CheckBoxDemo(),
              Text("默认地址",style: TextStyle(fontSize: 14, color: Colors.black),),
              Spacer(),
              FlatButton.icon(
                  onPressed: (){

                  },
                  icon: ImageIcon(AssetImage('images/my_address_list_edit.png'), color: Colors.black,),
                  label:  Text("编辑",style: TextStyle(fontSize: 14, color: Colors.black),)
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CheckBoxDemo extends StatefulWidget {
  const CheckBoxDemo({
    Key key,
  }) : super(key: key);

  @override
  _CheckBoxDemoState createState() => _CheckBoxDemoState();
}

class _CheckBoxDemoState extends State<CheckBoxDemo> {
  var isSelected = false;
  @override
  Widget build(BuildContext context) {
    return  Checkbox(
        value: isSelected,
        onChanged: (isCheck){
          if (isCheck) {
            Toast.showToast(msg: "改变了：$isCheck", context: context);
          }
          isSelected = isCheck;
          //改变_CheckBoxState
          setState(() {});
        });
  }
}
