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

class Otp extends StatefulWidget {
  String mobileNo;
  String otp;
  String countryCode;
  String userExist;
  String userId;
  Otp({Key key, this.mobileNo,this.otp,this.userExist,this.countryCode,this.userId}) : super(key: key);

  @override
  OtpState createState() => OtpState();
}

class OtpState extends State<Otp> {
  TextEditingController txtOtp = TextEditingController();
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void lastLogin() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget
        .of(context)
        .apiRepos
        .lastLogin(context: context, user_id:widget.userId);
    SharePreferencesHelper.getInstant().setString(
        SharePreferencesHelper.SHAREPREFERENCES_USER_ID,
        widget.userId);
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
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  if(txtOtp.text != widget.otp)
                    {
                    Utility.showAlertDialogCallBack(
                    context: context,
                    message: StringHelper.error_msg_invalid_otp);
                    }
                  else
                    {
                      if(widget.userExist == "0")
                        {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignupDetail(mobileNo: widget.mobileNo,countryCode: widget.countryCode,)),
                          );
                        }
                      else
                        {
                          lastLogin();

                        }
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
                  child: RichText(
                    text: TextSpan(
                        text: "We've sent a text message with a 6 digit code to ",
                        style: TextStyle(
                            color: Colors.black, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(text: widget.countryCode + " " + (widget.countryCode == "+61" ? widget.mobileNo.substring(1) : widget.mobileNo),
                              style: TextStyle(
                                  color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15),

                          ),
                          TextSpan(text: ". Enter the code below to verify your number, or just tap the link in the message.",
                            style: TextStyle(
                                color: Colors.black, fontSize: 15),

                          )
                        ]
                    ),
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
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Note: Your text message may take a few moments to',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'arrive. ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13),
                      ),
                      InkWell(onTap: (){
                        Navigator.pop(context);
                      },
                        child: Text(
                          'Change number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorsHelper.themeColor,
                              fontSize: 13),
                        ),
                      ),

                    ],
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
