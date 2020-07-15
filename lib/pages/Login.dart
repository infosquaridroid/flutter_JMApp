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
import 'package:jmapp/pages/Otp.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController txtmn = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focus = new FocusNode();


  int selectedCountry = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void sendotp() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .sendOtp(context: context, country_code: countryData.country[selectedCountry]["code"],mobile: txtmn.text);
    if (datas != null) {
      print(datas);
      if(datas["status"] == true)
        {
          if(datas["user_exist"].toString() == "1")
            {
              SharePreferencesHelper.getInstant().setString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID, datas["data"]["id"]);

            }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                  mobileNo:  txtmn.text,
                  otp: datas["data"]["otp"].toString(),
                  userExist: datas["user_exist"].toString(),countryCode:countryData.country[selectedCountry]["code"],userId: datas["user_exist"].toString() == "1" ? datas["data"]["id"] : "",
                )),
          );
        }
      else
        {
          Utility.showAlertDialogCallBack(
              context: context,
              message: datas["error"]);
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
          width: 150,
          fit: BoxFit.contain,
        ),
        backgroundColor: ColorsHelper.themeColor,
        leading: Container(),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Center(
              child: InkWell(
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  if(txtmn.text.length == 0)
                    {
                      Utility.showAlertDialogCallBack(
                          context: context,
                          message: StringHelper.error_msg_empty_mobile);
                    }
                  else if(txtmn.text.length != 10)
                  {
                    Utility.showAlertDialogCallBack(
                        context: context,
                        message: StringHelper.error_msg_invalid_mobile_10_digits);
                  }
                  else
                    {
                      sendotp();
                    }

                },
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(onTap: (){
        _focus.unfocus();

      },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                    'Simply enter your mobile number to activate Pushpay on this device.',
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
                            showPickerIcons(context);
                          },
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                countryData.country[selectedCountry]["image"],
                                height: 20,
                                fit: BoxFit.contain,
                              ),
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
                      style:
                          TextStyle(color: ColorsHelper.themeColor, fontSize: 13),
                    ),
                    Text(
                      ' and ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    Text(
                      'Privacy Policy.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: ColorsHelper.themeColor, fontSize: 13),
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
getCountryWidget()
{
  List<PickerItem<dynamic>> countryWidget = [];

  for (int i = 0; i < countryData.country.length; i++) {
    countryWidget.add(PickerItem(
        text: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 20,
              width: (20 * 512) / 342,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(countryData.country[i]["image"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Text(
              countryData.country[i]["name"] + " ("+countryData.country[i]["code"]+")",
              style: TextStyle(color: Colors.black, fontSize: 17),
            )
          ],
        ),
        value: i.toString()));
  }
  return countryWidget;
}
  showPickerIcons(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getCountryWidget()),height: 190,
      title: Text("Select Country",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17)),
      confirmTextStyle: TextStyle(
          color: ColorsHelper.themeColor,
          fontWeight: FontWeight.w600,
          fontSize: 17),
      cancelTextStyle: TextStyle(
          color: ColorsHelper.themeColor,
          fontWeight: FontWeight.w600,
          fontSize: 17),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List value) {
        selectedCountry = value[0];
        setState(() {

        });
        print(value[0]);
        print(picker.getSelectedValues()[0]);
      },magnification: 1.2,selecteds: [selectedCountry]
    ).show(_scaffoldKey.currentState);
  }
}
