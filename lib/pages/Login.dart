import 'dart:convert';

import 'package:jmapp/helpers/flag.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:jmapp/data_manager_inherited_widget.dart';
import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/countryData.dart';
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
import 'package:jmapp/pages/Otp.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:local_auth/local_auth.dart';
class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController txtmn = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focus = new FocusNode();

  int selectedCountry = 0;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500))
        .then((onValue) {
      SharePreferencesHelper.getInstant()
          .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID).then((value) {
        print(value);
        if(value != "")
        {
          biometric();

        }
      });
    });

  }
void biometric() async {
  if (await _isBiometricAvailable()) {
    await _authenticateUser();
  }
}
  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
        "Please authenticate to view your transaction overview",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Bottombar()),
      );
    }
  }
  void sendotp() async {
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => Otp(
//            mobileNo: txtmn.text,
//            otp: '123456',
//            userExist: '1',
//            countryCode: countryData.country[selectedCountry]["code"],
//            userId:  "",
//          )),
//    );
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .sendOtp(
            context: context,
            country_code: countryData.country[selectedCountry]["countries_isd_code"],
            mobile: txtmn.text);
    if (datas != null) {
      print(datas);
      if (datas["status"] == true) {

        SharePreferencesHelper.getInstant().setString(
            SharePreferencesHelper.SHAREPREFERENCES_USER_Data,
            jsonEncode(datas["data"]));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Otp(
                    mobileNo: txtmn.text,
                    otp: datas["data"]["otp"].toString(),
                    userExist: datas["user_exist"].toString(),
                    countryCode: countryData.country[selectedCountry]["countries_isd_code"],
                    userId: datas["user_exist"].toString() == "1"
                        ? datas["data"]["id"]
                        : "",
                  )),
        );
      } else {
        Utility.showAlertDialogCallBack(
            context: context, message: datas["message"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Image.asset(
          ImageAssets.main_icon,
          height: 40,
          fit: BoxFit.contain,
        ),
        backgroundColor: ColorsHelper.headerColor,
        leading: Container(),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Center(
              child: InkWell(
                child: Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: ColorsHelper.darkThemeColor),
                ),
                onTap: () {
                  if (txtmn.text.length == 0) {
                    Utility.showAlertDialogCallBack(
                        context: context,
                        message: StringHelper.error_msg_empty_mobile);
                  } else if (txtmn.text.replaceAll(" ", "").length != 10) {
                    Utility.showAlertDialogCallBack(
                        context: context,
                        message:
                            StringHelper.error_msg_invalid_mobile_10_digits);
                  } else {
                    sendotp();
                  }
                },
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          _focus.unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: ColorsHelper.bodyColor,
          child: SafeArea(
            child: ListView(
              physics: new ClampingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Text(
                    'Simply enter your mobile number to activate ' +
                        StringHelper.app_name +
                        ' on this device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Mobile Number',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 75,
                        child: InkWell(
                          onTap: () {
                            showCountryDialogCallBack(context: context);
                            _focus.unfocus();
                          },
                          child: Row(
                            children: <Widget>[
                              Flag(countryData.country[selectedCountry]["flag"],width: 25,fit: BoxFit.contain,),

                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                ImageAssets.dd,
                                height: 10,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsHelper
                                  .themeColor, //                   <--- border color
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        height: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: MediaQuery.of(context).size.width - 130,
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            focusNode: _focus,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            controller: txtmn,
                            cursorColor: ColorsHelper.themeColor,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: countryData.country[selectedCountry]
                                              ['countries_isd_code'] ==
                                          "+61"
                                      ? '#### ### ###'
                                      : '##########')
                            ],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter the mobile number"),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsHelper
                                  .themeColor, //                   <--- border color
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        height: 40,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'By activating the device with ' +
                      StringHelper.app_name +
                      ' you',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'agree to our ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    Text(
                      'Terms of use',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsHelper.darkThemeColor, fontSize: 13),
                    ),
                    Text(
                      ' and ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    Text(
                      'Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsHelper.darkThemeColor, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  showCountryDialogCallBack({@required BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            content: Container(
              width: double.maxFinite,
              child: Container(
                height: ((45 * countryData.country.length)).toDouble(),
                child: ListView.builder(
                  physics: new ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context1, int i) {
                    return InkWell(onTap: (){
                      setState(() {
                        if (i != selectedCountry) {
                          txtmn.text = "";
                        }
                        selectedCountry = i;
                        Navigator.pop(context);
                      });
                    },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flag(countryData.country[i]["flag"],width: 25,fit: BoxFit.contain,),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      countryData.country[i]["countries_name"] +
                                          " (" +
                                          countryData.country[i]["countries_isd_code"] +
                                          ")",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  i == selectedCountry ? Icon(Icons.check,
                                      color: ColorsHelper.themeColor, size: 20) : Container()
                                ],
                              ),
                            ),
                            Container(
                              height: i == countryData.country.length - 1 ? 0 : 1,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: countryData.country.length,
                ),
              ),
            ),
          );
        });
  }
}
