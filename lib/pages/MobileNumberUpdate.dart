import 'package:jmapp/helpers/flag.dart';
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
import 'package:jmapp/pages/UpdateOtp.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MobileNumberUpdate extends StatefulWidget {
  String mobileNo;
  String code;
  MobileNumberUpdate({Key key, this.mobileNo,this.code}) : super(key: key);

  @override
  MobileNumberUpdateState createState() => MobileNumberUpdateState();
}

class MobileNumberUpdateState extends State<MobileNumberUpdate> {
  TextEditingController txtmn = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focus = new FocusNode();
  String userId = "";

  int selectedCountry = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID)
        .then((value) {
          userId = value;
      txtmn.text = widget.mobileNo;
      for(int i=0;i<countryData.country.length;i++)
      {
        if(countryData.country[i]["countries_isd_code"] == widget.code)
        {
          selectedCountry = i;
        }
      }
      setState(() {

      });
    });
  }
  void sendotp() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .sendOtp(context: context, country_code: countryData.country[selectedCountry]["countries_isd_code"],mobile: txtmn.text);
    if (datas != null) {
      print(datas);
      if(datas["status"] == true)
      {

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateOtp(
                mobileNo:  txtmn.text,
                otp: datas["data"]["otp"].toString(),countryCode:countryData.country[selectedCountry]["countries_isd_code"],userId: userId,
              )),
        ).then((value) {
          if(value != null)
            {
              Navigator.pop(context,{"mobile":value["mobile"],"country_code":value["country_code"]});

            }
          print(value);
        });
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
      key: _scaffoldKey,
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
                    'Update Mobile Number',
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
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Text(
                    "Enter your new mobile number and we'll send a confirmation code to that new number.",
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
                              Flag(countryData.country[selectedCountry]["flag"], width: 25,fit: BoxFit.contain,),

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
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Your new mobile number won't be reflected until you've confirmed it.",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
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
                    child: Container(
                      child: Center(
                        child: Text(
                          "Confirm",
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
                                  Flag(countryData.country[i]["flag"], width: 25,fit: BoxFit.contain,),

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
