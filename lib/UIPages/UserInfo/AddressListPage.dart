import 'package:flutter/material.dart';
import 'package:xtflutter/UIPages/NormalUI/XTAppBackBar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTSizeFit.dart';
import 'package:xtflutter/Utils/Toast.dart';
import 'package:xtflutter/XTModel/UserInfoModel.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  void _xtback(BuildContext context) {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId, result: <String, dynamic>{'result': 'data from second'});
  }

  @override
  Widget build(BuildContext context) {
    List<AddressListModel> addressModels;

    Future refresh() async{
       return XTUserInfoRequest.obtainAddressList();
    }

    initState(){
      super.initState();
    }

    ///获取新增收货地址Button
    Widget buildAddNewAddressButton(){
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top:98),
        margin: EdgeInsets.only(top: 10),
        child: Container(
          padding: EdgeInsets.only(left: 98,right: 98),
          height: 40,
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.red,
              onPressed: (){
                XTRouter.pushToPage(
                  routerName: "addAddress",
                  context: context,
                ).then((value) {
                  refresh();
                  print("新增/修改地址成功后，地址列表刷新");
                });
              },
              child:Text("新增收货地址",style: TextStyle(fontSize: 15, color: Colors.white),
              )
          ),)
        ,
      );
    }

    ///获取复选框组件
    Widget buildCheckBox(AddressListModel model,bool isSelected){
      return  Checkbox(
          value: isSelected,
          onChanged: (isCheck){
            if (isCheck) {
              isSelected = isCheck;
              Future<bool> finish = XTUserInfoRequest.setDefaultAddress(model.id);
              print("地址ID："+ model.id.toString()+"状态:"+finish.toString());
              refresh();
              //改变_CheckBoxState
              setState(() {});
            }
          });
    }

    /// 获取ListViewCell
    Widget buildAddressListCell(AddressListModel model){
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(model.consignee,style: TextStyle(fontSize: 14, color: Colors.black),),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(model.phone,style: TextStyle(fontSize: 14, color: Colors.black),),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 15,right: 16),
                  child: Expanded(
                    child: Text(
                      model.address,
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
            Divider(height: 1,indent: 16,endIndent: 16,color: Color(0xFFEEEEEE),),
            Row(
              children: <Widget>[
                buildCheckBox(model,model.defaultAddress == 1),
                Text("默认地址",style: TextStyle(fontSize: 14, color: Colors.black),),
                Spacer(),
                FlatButton.icon(
                    onPressed: (){
                      Toast.showToast(msg: "编辑", context: context);
                      XTRouter.pushToPage(
                        routerName: "addAddress",
                        params: model.toJson(),
                        context: context,
                      ).then((value) {
                        refresh();
                        print("新增/修改地址成功后，地址列表刷新");
                      });
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

    ///获取ListView
    Widget buildAddressListView(List<AddressListModel> models){
      return ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemCount: models.length,
          itemBuilder: (context, index) {
            if (index == models.length - 1) {
              return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10, child: Container(color: Color(0xFFF9F9F9),),),
                    buildAddressListCell(models[index]),
                    SizedBox(
                      height: 10, child: Container(color: Color(0xFFF9F9F9),),),
                    buildAddNewAddressButton()
                  ]);
            } else {
              return Column(
                children: <Widget>[
                  SizedBox(height: 10, child: Container(color: Color(0xFFF9F9F9),),),
                  buildAddressListCell(models[index]),
                ],
              );
            }
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: xtBackBar(title: "我的收货地址", back: () => _xtback(context)),
      body: FutureBuilder(
          // ignore: missing_return
          future: refresh(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            print('data:${snapShot.data}');
            print('connectionState:${snapShot.connectionState}');
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else {
              if(snapShot.hasData){
                addressModels = snapShot.data;
                return buildAddressListView(addressModels);
//                return Text(snapShot.data.toString());
              }else{
                return Text('NoData...');
              }
            }
          }),
    );
  }
}



