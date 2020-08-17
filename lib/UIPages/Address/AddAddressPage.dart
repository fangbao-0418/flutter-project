import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xtflutter/XTConfig/AppConfig/XTRouter.dart';
import '../NormalUI/XTAppBackBar.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:xtflutter/XTNetWork/UserInfoRequest.dart';
import 'package:flutter_picker/Picker.dart';
import '../../Utils/Toast.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

void _xtback(BuildContext context) {
  final BoostContainerSettings settings = BoostContainer.of(context).settings;
  FlutterBoost.singleton.close(settings.uniqueId, result: <String, dynamic>{'result': 'data from second'});
}

class _AddAddressPageState extends State<AddAddressPage> {
  /// 收货人
  final TextEditingController receiveTextCon = TextEditingController();
  /// 手机号
  final TextEditingController phoneTextCon = TextEditingController();
  /// 地区
  final TextEditingController addressTextCon = TextEditingController();
  /// 是否选中默认地址
  var isSelected = false;
  /// 地区文案
  String selectAddrStr = "选择地区";
  /// 选中行，默认全部第一行
  List<int> selectValue = [0, 0, 0];
  /// 城市区域列表
  List cityNameList = [];
  List cityValueList = [];
  /// 地址信息
  AddressCityModel cityInfoModel = AddressCityModel(provinceId: "", cityId: "", areaId: "");

  @override
  void initState() {
    super.initState();
    getCityList();
  }

  @override
  void dispose() {
    receiveTextCon.dispose();
    phoneTextCon.dispose();
    addressTextCon.dispose();
    super.dispose();
  }

  void showToast(String msg) {
    Toast.showToast(msg: msg, context: context);
  }

  void saveAddressAction() async {
    if (receiveTextCon.text.isEmpty) {
      showToast("请填写收货人");
      return;
    }
    if (phoneTextCon.text.isEmpty) {
      showToast("请填写手机号码");
      return;
    }
    if (phoneTextCon.text.length < 11) {
      showToast("请输入正确的手机号码");
      return;
    }
    if (cityInfoModel.infoIsEmpty()) {
      showToast("请选择省份");
      return;
    }
    if (addressTextCon.text.isEmpty) {
      showToast("请填写详细地址");
      return;
    }

    Map<String, String> params = {
      "consignee": receiveTextCon.text,
      "provinceId": cityInfoModel.provinceId,
      "cityId": cityInfoModel.cityId,
      "districtId": cityInfoModel.areaId,
      "street": addressTextCon.text,
      "phone": phoneTextCon.text,
      "defaultAddress": isSelected ? "1" : "0"
    };
    addressInfoRequest(params, true);
  }

  /// 地址请求
  void addressInfoRequest(Map<String, String> params, bool isAdd) async {
    try {
      final result = await XTUserInfoRequest.addressInfoRequest(params, isAdd);
      bool isSuccess = result["success"];
      String msg = result["message"];
      if (isSuccess) {
        XTRouter.closePage(context: context);
      } else {
        showToast(msg);
      }
    } catch (error) {
      print("flutter address error == ${error.toString()}");
    }
  }

  /// 展示地址选择窗
  void showPicker(List data) {
    Picker picker = Picker(
      height: 300,
      itemExtent: 40,
      selecteds: selectValue,
      adapter: PickerDataAdapter<String>(pickerdata: data),
      changeToFirst: false,
      textAlign: TextAlign.left,
      textStyle: const TextStyle(fontSize: 15, color: Colors.black),
      selectedTextStyle: TextStyle(fontSize: 15, color: Colors.black),
      columnPadding: const EdgeInsets.all(8.0),
      title: Text("所在地区", style: TextStyle(fontSize: 16, color: Colors.black)),
      cancelText: "取消",
      cancelTextStyle: TextStyle(fontSize: 14, color: Color(0xff4d88ff)),
      confirmText: "确定",
      confirmTextStyle: TextStyle(fontSize: 14, color: Color(0xff4d88ff)),
      onConfirm: (Picker picker, List value) {
        /// 记录选中行
        selectValue = value;
        /// 获取地区code
        Map firstValue = cityValueList[value[0]];
        String firstCode = firstValue.keys.first;
        Map secondValue = firstValue[firstCode][value[1]];
        String secondCode = secondValue.keys.first;
        String thirdCode = secondValue[secondCode][value[2]];
        /// 选中地区
        setState(() {
          selectAddrStr = picker.getSelectedValues().toString().replaceAll("[", "").replaceAll("]", "").replaceAll(",", " ");
          cityInfoModel = AddressCityModel(provinceId: firstCode, cityId: secondCode, areaId: thirdCode);
        });
      }
    );
    picker.showModal(context);
  }

  /// 获取省市区数据
  void getCityList() async {
    try {
      Map dataMap = await XTUserInfoRequest.getCityList();
      cityNameList = dataMap["cityName"];
      cityValueList = dataMap["cityValue"];
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(title: "添加地址", back: () => _xtback(context)),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: Colors.white,
            child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(height: 10, color: Color(0xFFF9F9F9)),
                    receiverAndPhoneView(true),
                    Container(height: 1.5, color: Color(0xFFF9F9F9), margin: EdgeInsets.only(left: 15, right: 15)),
                    receiverAndPhoneView(false),
                    Container(height: 10, color: Color(0xFFF9F9F9)),
                    addressView(),
                    Container(height: 10, color: Color(0xFFF9F9F9)),
                    selectAction(),
                    SizedBox(height: 80),
                    saveButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget receiverAndPhoneView(bool isReveive) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(isReveive ? "收货人：" : "手机号：", style: TextStyle(color: Colors.black, fontSize: 14)),
          Expanded(
            child: TextField(
              controller: isReveive ? receiveTextCon : phoneTextCon,
              inputFormatters: [
                LengthLimitingTextInputFormatter(isReveive ? 20 : 11)
              ],
              keyboardType: isReveive ? TextInputType.text : TextInputType.phone,
              decoration: InputDecoration(
                hintText: isReveive ? "请填写收货人" : "请填写手机号",
                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 14),
                contentPadding: EdgeInsets.only(left: 15, right: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressView() {
    return Container(
      height: 150,
      padding: EdgeInsets.only(left: 15),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showPicker(cityNameList);
            },
            child: Container(
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(selectAddrStr, style: TextStyle(color: Colors.black, fontSize: 14)),
                  Icon(Icons.keyboard_arrow_right, color: Color(0xffb9b5b5),)
                ],
              ),
            ),
          ),
          Container(height: 1.5, color: Color(0xFFF9F9F9), margin: EdgeInsets.only(left: 15, right: 15)),
          Expanded(
            child: TextField(
              controller: addressTextCon,
              maxLines: 5,
              keyboardType: TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(40)
              ],
              decoration: InputDecoration(
                hintText: "请填写详细地址（比如街道、小区、乡镇、村）",
                hintStyle: TextStyle(color: Color(0xffb9b5b5), fontSize: 14),
                contentPadding: EdgeInsets.only(top: 5, right: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectAction() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: Colors.red,
            hoverColor: Colors.red,
            value: isSelected, 
            onChanged: (value) {
              setState(() {
                isSelected = value;
              });
            }
          ),
          Text("设置默认地址", style: TextStyle(color: Colors.black, fontSize: 14))
        ]
      ),
    );
  }

  Widget saveButton() {
    return RaisedButton(
      color: Color(0xffe60113),
      child: Text(
        "保存并使用",
        style: TextStyle(color: Colors.white, fontSize: 16)
      ),
      padding: EdgeInsets.only(left: 40, right: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      onPressed: () {
        saveAddressAction();
      },
    );
  }
}

class AddressCityModel {
  AddressCityModel({this.provinceId, this.cityId, this.areaId});

  String provinceId = "";
  String cityId = "";
  String areaId = "";

  bool infoIsEmpty() {
    return provinceId.isEmpty || cityId.isEmpty || areaId.isEmpty;
  }
}