import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xtflutter/config/app_config/method_config.dart';
import 'package:xtflutter/pages/normal/app_nav_bar.dart';
import 'package:xtflutter/pages/normal/loading.dart';
import 'package:xtflutter/pages/normal/toast.dart';
import 'package:xtflutter/utils/appconfig.dart';
import 'package:xtflutter/config/app_config/color_config.dart';
import 'package:xtflutter/model/userinfo_model.dart';
import 'package:xtflutter/router/router.dart';
import 'package:xtflutter/net_work/userinfo_request.dart';
import 'package:flutter_picker/Picker.dart';

class AddAddressPage extends StatefulWidget {
  static String routerName = "addAddress";

  AddAddressPage({this.name, this.params});

  /// 路由名称
  final String name;

  /// 传过来的参数
  final Map<String, dynamic> params;

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  /// 是否是添加地址
  bool _isAddAddress = true;

  /// 地址修改id
  int _editAddrId;

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
  List cityNameList = AppConfig.cityNameList;
  List cityValueList = AppConfig.cityValueList;

  /// 地址信息
  AddressCityModel cityInfoModel =
      AddressCityModel(provinceId: "", cityId: "", areaId: "");

  bool isOnFocusName = false;
  bool isOnFocusPhone = false;

  @override
  void initState() {
    super.initState();

    /// 编辑地址参数
    if (widget.params.isNotEmpty && widget.params.containsKey("consignee")) {
      AddressListModel addressInfo = AddressListModel.fromJson(widget.params);
      _isAddAddress = false;
      _editAddrId = addressInfo.id;
      receiveTextCon.text = addressInfo.consignee;
      phoneTextCon.text = addressInfo.phone;
      selectAddrStr =
          "${addressInfo.province} ${addressInfo.city} ${addressInfo.district}";
      cityInfoModel = AddressCityModel(
          provinceId: addressInfo.provinceId.toString(),
          cityId: addressInfo.cityId.toString(),
          areaId: addressInfo.districtId.toString());
      addressTextCon.text = addressInfo.street;
      isSelected = addressInfo.defaultAddress == 1 ? true : false;
    }
    if (cityNameList.isEmpty && cityValueList.isEmpty) {
      /// 没有缓存数据
      getCityList();
    } else {
      /// 有缓存数据
      setSelectValue();
    }
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

  void saveAddressAction() {
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
    if (!_isAddAddress) {
      params["id"] = _editAddrId.toString();
    }
    addressInfoRequest(params, _isAddAddress);
  }

  /// 地址请求
  void addressInfoRequest(Map<String, String> params, bool isAdd) async {
    Loading.show(context: context);
    XTUserInfoRequest.addressInfoRequest(params, isAdd).then((value) {
      showToast(_isAddAddress ? "保存成功" : "修改成功");
      XTRouter.closePage(context: context, result: {"isRefresh": true});
    }).catchError((err) {
      showToast(err.message);
    }).whenComplete(() {
      Loading.hide();
    });
  }

  /// 展示地址选择窗
  void showPicker(List data) {
    _closeKeyboard();
    Picker picker = Picker(
        height: 300,
        itemExtent: 40,
        selecteds: [selectValue[0], selectValue[1], selectValue[2]],
        adapter: PickerDataAdapter<String>(pickerdata: data),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(fontSize: 15, color: Colors.black),
        selectedTextStyle: TextStyle(fontSize: 15, color: Colors.black),
        columnPadding: const EdgeInsets.all(8.0),
        title:
            Text("所在地区", style: TextStyle(fontSize: 16, color: Colors.black)),
        cancelText: "取消",
        cancelTextStyle: TextStyle(fontSize: 14, color: xtColor_4D88FF),
        confirmText: "确定",
        confirmTextStyle: TextStyle(fontSize: 14, color: xtColor_4D88FF),
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
            selectAddrStr = picker
                .getSelectedValues()
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .replaceAll(",", " ");
            cityInfoModel = AddressCityModel(
                provinceId: firstCode, cityId: secondCode, areaId: thirdCode);
          });
        });
    picker.showModal(context);
  }

  /// 获取省市区数据
  void getCityList() {
    try {
      XTUserInfoRequest.getCityList().then((dataMap) {
        cityNameList = dataMap["cityName"];
        cityValueList = dataMap["cityValue"];
        AppConfig.updateCityNameList(cityNameList);
        AppConfig.updateCityValueList(cityValueList);

        setSelectValue();
      });
    } catch (err) {
      print(err);
    }
  }

  /// 初始化选中行
  void setSelectValue() {
    int firstValue = 0;
    int secondValue = 0;
    int thirdValue = 0;
    if (!_isAddAddress) {
      for (int i = 0; i < cityValueList.length; i++) {
        Map firstMap = cityValueList[i];
        if (firstMap.containsKey(cityInfoModel.provinceId)) {
          firstValue = i;
          break;
        }
      }
      List cityList = cityValueList[firstValue][cityInfoModel.provinceId];
      for (int i = 0; i < cityList.length; i++) {
        Map secondMap = cityList[i];
        if (secondMap.containsKey(cityInfoModel.cityId)) {
          secondValue = i;
          break;
        }
      }
      List areaList = cityValueList[firstValue][cityInfoModel.provinceId]
          [secondValue][cityInfoModel.cityId];
      thirdValue = areaList.indexOf(cityInfoModel.areaId);

      selectValue = [firstValue, secondValue, thirdValue];
    }
  }

  /// 清除输入框
  void _clearTextAction(TextEditingController controller) {
    controller.clear();
  }

  /// 键盘收起
  void _closeKeyboard({bool isClose = true}) {
    if (isClose) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    setState(() {
      isOnFocusName = false;
      isOnFocusPhone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: xtBackBar(
          title: _isAddAddress ? "添加地址" : "编辑地址",
          back: () => XTRouter.closePage(context: context)),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _closeKeyboard(),
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(height: 10, color: xtColor_F9F9F9),
                    receiverAndPhoneView(true),
                    Container(
                        height: 1.5,
                        color: xtColor_F9F9F9,
                        margin: EdgeInsets.only(left: 15, right: 15)),
                    receiverAndPhoneView(false),
                    Container(height: 10, color: xtColor_F9F9F9),
                    addressView(),
                    Container(height: 10, color: xtColor_F9F9F9),
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
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(isReveive ? "收货人：" : "手机号：",
              style: TextStyle(color: Colors.black, fontSize: 14)),
          Expanded(
            child: TextField(
              controller: isReveive ? receiveTextCon : phoneTextCon,
              inputFormatters: [
                LengthLimitingTextInputFormatter(isReveive ? 20 : 11)
              ],
              keyboardType:
                  isReveive ? TextInputType.text : TextInputType.phone,
              decoration: InputDecoration(
                hintText: isReveive ? "请填写收货人" : "请填写手机号",
                hintStyle: TextStyle(color: xtColor_B9B5B5, fontSize: 14),
                contentPadding: EdgeInsets.only(left: 15, right: 15),
                border: InputBorder.none,
                suffixIconConstraints: BoxConstraints(
                  minHeight: 15,
                  minWidth: 15
                ),
                suffixIcon: (isReveive ? isOnFocusName : isOnFocusPhone) ? xtTextFieldClear(
                  onPressed: () {
                    _clearTextAction(isReveive ? receiveTextCon : phoneTextCon);
                  }
                ) : null,
              ),
              onEditingComplete: () => _closeKeyboard(),
              onTap: () {
                setState(() {
                  isOnFocusName = isReveive;
                  isOnFocusPhone = !isReveive;
                });
              },
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
                  Text(selectAddrStr,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: xtColor_B9B5B5,
                  )
                ],
              ),
            ),
          ),
          Container(
              height: 1.5,
              color: xtColor_F9F9F9,
              margin: EdgeInsets.only(left: 15, right: 15)),
          Expanded(
            child: TextField(
              controller: addressTextCon,
              maxLines: 5,
              keyboardType: TextInputType.text,
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
              decoration: InputDecoration(
                hintText: "请填写详细地址（比如街道、小区、乡镇、村）",
                hintStyle: TextStyle(color: xtColor_B9B5B5, fontSize: 14),
                contentPadding: EdgeInsets.only(top: 5, right: 15),
                border: InputBorder.none,
              ),
              onTap: () => _closeKeyboard(isClose: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectAction() {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: FlatButton.icon(
          onPressed: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          icon: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? mainRedColor : main99GrayColor,
          ),
          label: Text("设置默认地址",
              style: TextStyle(color: Colors.black, fontSize: 14))),
    );
  }

  Widget saveButton() {
    return RaisedButton(
      color: mainRedColor,
      child: Text(_isAddAddress ? "保存并使用" : "保存修改",
          style: TextStyle(color: Colors.white, fontSize: 16)),
      padding: EdgeInsets.only(left: 40, right: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
