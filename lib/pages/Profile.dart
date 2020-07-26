import 'dart:convert';

import 'package:jmapp/helpers/flag.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:jmapp/data_manager_inherited_widget.dart';
import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/timezoneData.dart';
import 'package:jmapp/helpers/utility.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/pages/MobileNumberUpdate.dart';
import 'package:jmapp/pages/SignupDetail.dart';
import 'package:jmapp/helpers/custom_expansion_tile.dart' as custom;
import 'package:jmapp/helpers/countryData.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtAddress1 = TextEditingController();
  TextEditingController txtCity = TextEditingController();
  TextEditingController txtState = TextEditingController();
  TextEditingController txtZip = TextEditingController();
  String userId = "";
  String email = "";
  String mobile = "";
  String role = "";
  String countryCode = "";
  bool isEmailVerified = false;
  bool isUpdateEmail = false;
  int selectedCountry = -1;
  int selectedTimezone = -1;
  var userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getUser();
  }

  void getUser() async {
    userId = await SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID);
    userData = jsonDecode(await SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_Data));
    txtFirstName.text = userData["first_name"];
    txtLastName.text = userData["last_name"];
    txtAddress1.text = userData["street"];
    txtState.text = userData["state"];
    txtCity.text = userData["city"];
    txtZip.text = userData["postcode"];
    isEmailVerified = userData["verified"] == "Yes";
    email = userData["email"];
    txtEmail.text = userData["email"];
    mobile = userData["mobile"];
    countryCode = userData["country_code"];
    role = userData["role"] == null ? "Admin" : userData["role"];
    for (int i = 0; i < countryData.country.length; i++) {
      if (countryData.country[i]["countries_name"] == userData["country"]) {
        selectedCountry = i;
      }
    }
    for (int i = 0; i < timezoneData.timezone.length; i++) {
      if (timezoneData.timezone[i]["name"] == userData["time_zone"]) {
        selectedTimezone = i;
      }
    }
    setState(() {});
  }

  void update() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .updateUserDetail(
            context: context,
            first_name: txtFirstName.text,
            last_name: txtLastName.text,
            email: txtEmail.text,
            address: txtAddress1.text,
            city: txtCity.text,
            country: countryData.country[selectedCountry]["countries_name"],
            time_zone: timezoneData.timezone[selectedTimezone]["name"],
            postcode: txtZip.text,
            state: txtState.text,
            role: role,
            user_id: userId);
    if (datas != null) {
      print(datas);
      if (datas["status"] == true) {
        userData["first_name"] = txtFirstName.text;
        userData["last_name"] = txtLastName.text;
        userData["email"] = txtEmail.text;
        userData["street"] = txtAddress1.text;
        userData["city"] = txtCity.text;
        userData["country"] = countryData.country[selectedCountry]["countries_name"];
        userData["time_zone"] = timezoneData.timezone[selectedTimezone]["name"];
        userData["postcode"] = txtZip.text;
        userData["state"] = txtState.text;
        userData["role"] = role;
        SharePreferencesHelper.getInstant()
            .setString(SharePreferencesHelper.SHAREPREFERENCES_USER_Data,jsonEncode(userData));
        Utility.showAlertDialogCallBack(
            context: context, message: datas["message"]);
      } else {
        Utility.showAlertDialogCallBack(
            context: context, message: datas["message"]);
      }
    }
  }

  void moveToSecondPage() async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MobileNumberUpdate(
                mobileNo: mobile,
                code: countryCode,
              )),
    );
    if (information != null) {
      mobile = information["mobile"];
      countryCode = information["country_code"];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: ColorsHelper.headerColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorsHelper.bodyColor,
        child: SafeArea(
          child: Container(
            child: ListView(
              physics: new ClampingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 1,
                  color: Colors.black45,
                ),
                custom.ExpansionTile(
                  headerBackgroundColor: Colors.transparent,
                  iconColor: Colors.black,
                  initiallyExpanded: true,
                  title: Text(
                    "Personal details",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
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
                      width: MediaQuery.of(context).size.width,
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
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
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Email address',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                    ),
                    isUpdateEmail
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              width: MediaQuery.of(context).size.width - 40,
                              child: Center(
                                child: TextField(
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                  cursorColor: ColorsHelper.themeColor,
                                  controller: txtEmail,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter the Email Address"),
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
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      isEmailVerified
                                          ? 'Confirmed: '
                                          : 'Unconfirmed: ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      email,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.only(top: 5),
                                child: InkWell(
                                  onTap: () {
                                    isUpdateEmail = true;
                                    setState(() {});
                                  },
                                  child: Text(
                                    'Update email address',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ColorsHelper.themeColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            ImageAssets.phone,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            countryCode + mobile,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 5),
                      child: InkWell(
                        onTap: () {
                          moveToSecondPage();
                        },
                        child: Text(
                          'Update mobile number',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: ColorsHelper.themeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.black45,
                ),
                custom.ExpansionTile(
                    headerBackgroundColor: Colors.transparent,
                    iconColor: Colors.black,
                    initiallyExpanded: true,
                    title: Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Mailing address',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width - 40,
                          child: Center(
                            child: TextField(textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              cursorColor: ColorsHelper.themeColor,
                              controller: txtAddress1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address"),
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
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width - 40,
                          child: Center(
                            child: TextField(textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              cursorColor: ColorsHelper.themeColor,
                              controller: txtCity,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: "City"),
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
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width - 40,
                          child: Center(
                            child: TextField(textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              cursorColor: ColorsHelper.themeColor,
                              controller: txtState,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: "State"),
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
                      Container(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: MediaQuery.of(context).size.width - 200,
                            top: 15),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: TextField(textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              cursorColor: ColorsHelper.themeColor,
                              controller: txtZip,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Zip / Postcode"),
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
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width - 40,
                          child: InkWell(
                            onTap: () {
                              showCountryDialogCallBack(context: context);
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    selectedCountry == -1
                                        ? ''
                                        : countryData.country[selectedCountry]
                                            ["countries_name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                ),
                                Image.asset(
                                  ImageAssets.dd,
                                  height: 10,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 10,
                                )
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
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Time Zone',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width - 40,
                          child: InkWell(
                            onTap: () {
                              showTimezoneDialogCallBack(context: context);
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    selectedTimezone == -1
                                        ? ''
                                        : timezoneData
                                            .timezone[selectedTimezone]["name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Image.asset(
                                  ImageAssets.dd,
                                  height: 10,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 10,
                                )
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
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          "Your country and timezone are used to help display information in the correct format for you",
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ]),
                Container(
                  height: 1,
                  color: Colors.black45,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      if (txtFirstName.text.length == 0) {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: StringHelper.error_firstname_empty_value);
                      } else if (txtLastName.text.length == 0) {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: StringHelper.error_lastname_empty_value);
                      } else if (txtEmail.text.length == 0 && isUpdateEmail) {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: StringHelper.error_msg_empty_email);
                      } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(txtEmail.text) &&
                          isUpdateEmail) {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: StringHelper.error_msg_invalid_email);
                      } else if (txtAddress1.text.length == 0) {
                        Utility.showAlertDialogCallBack(
                            context: context, message: 'Please enter address');
                      } else if (txtState.text.length == 0) {
                        Utility.showAlertDialogCallBack(
                            context: context, message: 'Please enter state');
                      } else if (txtCity.text.length == 0) {
                        Utility.showAlertDialogCallBack(
                            context: context, message: 'Please enter city');
                      } else if (txtZip.text.length == 0) {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: 'Please enter zip/postal code');
                      } else if (selectedCountry == -1) {
                        Utility.showAlertDialogCallBack(
                            context: context, message: 'Please select country');
                      } else if (selectedTimezone == -1) {
                        Utility.showAlertDialogCallBack(
                            context: context,
                            message: 'Please select timezone');
                      } else {
                        update();
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Update Info",
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
                SizedBox(
                  height: 20,
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
                                      countryData.country[i]["countries_name"],
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
  showTimezoneDialogCallBack({@required BuildContext context}) {
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
                height: ((45 * timezoneData.timezone.length)).toDouble(),
                child: ListView.builder(
                  physics: new ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context1, int i) {
                    return InkWell(onTap: (){
                      setState(() {

                        selectedTimezone = i;
                        Navigator.pop(context);
                      });
                    },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 25,
                                   width: 1,
                                  ),

                                  Expanded(
                                    child: Text(
                                      timezoneData.timezone[i]["name"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),overflow: TextOverflow.ellipsis,maxLines: 1,
                                    ),
                                  ),
                                  i == selectedTimezone ? Icon(Icons.check,
                                      color: ColorsHelper.themeColor, size: 20) : Container()
                                ],
                              ),
                            ),
                            Container(
                              height: i == timezoneData.timezone.length - 1 ? 0 : 1,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: timezoneData.timezone.length,
                ),
              ),
            ),
          );
        });
  }

}
