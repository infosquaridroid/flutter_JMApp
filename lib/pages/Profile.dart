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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID)
        .then((value) {
      userId = value;
      getUser();
    });
  }

  void getUser() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .getUserDetail(context: context, user_id: userId);
    if (datas != null) {
      print(datas);
      if (datas["status"] == true) {
        var data = datas["data"];
        txtFirstName.text = data["first_name"];
        txtLastName.text = data["last_name"];
        txtAddress1.text = data["street"];
        txtState.text = data["state"];
        txtCity.text = data["city"];
        txtZip.text = data["postcode"];
        isEmailVerified = data["verified"] == "Yes";
        email = data["email"];
        txtEmail.text = data["email"];
        mobile = data["mobile"];
        countryCode = data["country_code"];
        role = data["role"];
        for(int i=0;i<countryData.country.length;i++)
          {
            if(countryData.country[i]["name"] == data["country"])
              {
                selectedCountry = i;
              }
          }
        for(int i=0;i<timezoneData.timezone.length;i++)
        {
          if(timezoneData.timezone[i]["name"] == data["time_zone"])
          {
            selectedTimezone = i;
          }
        }
        setState(() {});
      }
    }
  }

  void update() async {
    Map<String, dynamic> datas =
        await DataManagerInheritedWidget.of(context).apiRepos.updateUserDetail(
              context: context,
              first_name: txtFirstName.text,
              last_name: txtLastName.text,
              email: txtEmail.text,
              address: txtAddress1.text,
              city: txtCity.text,
              country: countryData.country[selectedCountry]["name"],
              time_zone: timezoneData.timezone[selectedTimezone]["name"],
              postcode: txtZip.text,
              state: txtState.text,role: role,user_id: userId
            );
    if (datas != null) {
      print(datas);
      if (datas["status"] == true) {
        Utility.showAlertDialogCallBack(
            context: context, message: datas["message"],isOnlyOK: true,onOkClick: (){
              Navigator.pop(context);
        });
      } else {
        Utility.showAlertDialogCallBack(
            context: context, message: datas["error"]);
      }
    }
  }
  void moveToSecondPage() async {
    final information = await  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MobileNumberUpdate(mobileNo: mobile,code: countryCode,)),
    );
    mobile = information["mobile"];
    countryCode = information["country_code"];
    setState(() {

    });
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
        backgroundColor: ColorsHelper.themeColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                          child: TextField(
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
                          child: TextField(
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
                      child: InkWell(onTap: (){
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
                            child: TextField(
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
                            child: TextField(
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
                            child: TextField(
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
                            child: TextField(
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
                              showCountryPicker(context);
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    selectedCountry == -1
                                        ? ''
                                        : countryData.country[selectedCountry]
                                            ["name"],
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
                              showTimezonePicker(context);
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

  getCountryWidget() {
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
              SizedBox(
                width: 10,
              ),
              Text(
                countryData.country[i]["name"],
                style: TextStyle(color: Colors.black, fontSize: 17),
              )
            ],
          ),
          value: i.toString()));
    }
    return countryWidget;
  }

  showCountryPicker(BuildContext context) {
    Picker(
            adapter: PickerDataAdapter(data: getCountryWidget()),
            height: 190,
            title: Text("Select Country",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 17)),
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
              setState(() {});
              print(value[0]);
              print(picker.getSelectedValues()[0]);
            },
            magnification: 1.2,
            selecteds: [selectedCountry == -1 ? 0 : selectedCountry])
        .show(_scaffoldKey.currentState);
  }

  getTimezoneWidget() {
    List<PickerItem<dynamic>> countryWidget = [];

    for (int i = 0; i < timezoneData.timezone.length; i++) {
      countryWidget.add(PickerItem(
          text: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                timezoneData.timezone[i]["name"],
                style: TextStyle(color: Colors.black, fontSize: 17),
              )
            ],
          ),
          value: i.toString()));
    }
    return countryWidget;
  }

  showTimezonePicker(BuildContext context) {
    Picker(
            adapter: PickerDataAdapter(data: getTimezoneWidget()),
            height: 190,
            title: Text("Select Timezone",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 17)),
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
              selectedTimezone = value[0];
              setState(() {});
              print(value[0]);
              print(picker.getSelectedValues()[0]);
            },
            magnification: 1.2,
            selecteds: [selectedTimezone == -1 ? 0 : selectedTimezone])
        .show(_scaffoldKey.currentState);
  }
}
