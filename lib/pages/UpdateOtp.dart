import 'dart:convert';

import 'package:jmapp/data_manager_inherited_widget.dart';
import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/utility.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/pages/Bottombar.dart';
import 'package:jmapp/pages/SignupDetail.dart';

class UpdateOtp extends StatefulWidget {
  String mobileNo;
  String otp;
  String countryCode;
  String userId;
  UpdateOtp({Key key, this.mobileNo,this.otp,this.countryCode,this.userId}) : super(key: key);

  @override
  UpdateOtpState createState() => UpdateOtpState();
}

class UpdateOtpState extends State<UpdateOtp> {
  TextEditingController txtOtp = TextEditingController();
  FocusNode _focus = new FocusNode();
  var userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_Data).then((value) {
      userData = jsonDecode(value);
    });
  }

  void sendotp() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .updateMobile(context: context, country_code: widget.countryCode,mobile: widget.mobileNo,userId: widget.userId);
    if (datas != null) {
      print(datas);
      if(datas["status"] == true)
      {
        userData["mobile"] = widget.mobileNo;
       userData["country_code"] = widget.countryCode;
        SharePreferencesHelper.getInstant()
            .setString(SharePreferencesHelper.SHAREPREFERENCES_USER_Data,jsonEncode(userData));
        Utility.showAlertDialogCallBack(
            context: context, message: datas["message"]);
        Navigator.pop(context,{"mobile":widget.mobileNo,"country_code":widget.countryCode});

      }
      else
      {
        Utility.showAlertDialogCallBack(
            context: context,
            message: datas["message"]);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          'Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,),maxLines: 2,textAlign: TextAlign.center,
        ),
        backgroundColor: ColorsHelper.headerColor,

      ),
      body: GestureDetector(onTap: (){
        _focus.unfocus();

      },
        child: Container(
          height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,color: ColorsHelper.bodyColor,
        child: SafeArea(
            child: ListView(
              physics: new ClampingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Verify Mobile Number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 1,
                  color: Colors.black45,
                ), SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Text(
                    "Please enter the code we send to confirm your new mobile number.",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Enter the 6 digit code',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: PinTextFieldFocus(
                    controller: txtOtp,
                    txtStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.black),
                    save: (val) {
                      setState(() {});
                      print(val);
                    },focus: _focus,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      if(txtOtp.text != widget.otp)
                      {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: StringHelper.error_msg_invalid_otp);
                      }
                      else
                      {
                        sendotp();
                      }

                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsHelper
                                .themeColor, //                   <--- border color
                            width: 1.0,
                          ),
                          color: ColorsHelper.themeColor,
                          borderRadius: BorderRadius.circular(5)),
                      height: 45,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsHelper.themeColor,
                              fontSize: 17),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsHelper
                                .themeColor, //                   <--- border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      height: 45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
