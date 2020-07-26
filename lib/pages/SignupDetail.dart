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

class SignupDetail extends StatefulWidget {
  String mobileNo;
  String countryCode;

  SignupDetail({Key key, this.mobileNo,this.countryCode}) : super(key: key);

  @override
  SignupDetailState createState() => SignupDetailState();
}

class SignupDetailState extends State<SignupDetail> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void signup() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .signup(context: context,first_name: txtFirstName.text,last_name: txtLastName.text,email: txtEmail.text,mobile:widget.mobileNo,country_code: widget.countryCode);
    if (datas != null) {
      print(datas);
      if(datas["status"] == true)
      {
        SharePreferencesHelper.getInstant().setString(
            SharePreferencesHelper.SHAREPREFERENCES_USER_Data,
            jsonEncode(datas["data"]));
       lastLogin(datas["data"]["id"]);
      }
      else
      {
        Utility.showAlertDialogCallBack(
            context: context,
            message: datas["message"]);
      }
    }
  }
  void lastLogin(userId) async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget
        .of(context)
        .apiRepos
        .lastLogin(context: context, user_id:userId);
    SharePreferencesHelper.getInstant().setString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID, userId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Bottombar()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          ImageAssets.main_icon,
          height: 40,
          fit: BoxFit.contain,
        ),
        backgroundColor: ColorsHelper.headerColor,

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
                  if(txtFirstName.text.length == 0)
                  {
                    Utility.showAlertDialogCallBack(
                        context: context,
                        message: StringHelper.error_firstname_empty_value);
                  }
                  else if(txtLastName.text.length == 0)
                  {
                    Utility.showAlertDialogCallBack(
                        context: context,
                        message: StringHelper.error_lastname_empty_value);
                  }
                  else if(txtEmail.text.length == 0)
                  {
                    Utility.showAlertDialogCallBack(
                        context: context,
                        message: StringHelper.error_msg_empty_email);
                  }
                  else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(txtEmail.text))
                    {
                      Utility.showAlertDialogCallBack(
                          context: context,
                          message: StringHelper.error_msg_invalid_email);
                    }
                  else
                    {
                      signup();
                    }
                },
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,color: ColorsHelper.bodyColor,
        child: SafeArea(
          child: ListView(
            physics: new ClampingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Please enter your personal details.",
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
                  'First Name',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Center(
                    child: TextField(textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      cursorColor: ColorsHelper.themeColor,
                      controller: txtFirstName,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the first name"),
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
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Last Name',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Center(
                    child: TextField(textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      cursorColor: ColorsHelper.themeColor,
                      controller: txtLastName,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the last name"),
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
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Email',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      cursorColor: ColorsHelper.themeColor,
                      controller: txtEmail,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the email"),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
