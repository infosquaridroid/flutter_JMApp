
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:jmapp/data_manager_inherited_widget.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {
  static VoidCallback onPosClick, onNavClick;

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  static showAlertDialogCallBack({@required BuildContext context,
  var message = 'Something went wrong'}){
//    Fluttertoast.showToast(
//        msg: message,
//        toastLength:Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIosWeb: 2,
//        backgroundColor: hexToColor('#000000').withAlpha(150),
//        textColor: Colors.white,
//        fontSize: 16.0,
//    );
     FToast fToast = FToast(context);

    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black.withAlpha(150),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Text(message,style: TextStyle(color: Colors.white,fontSize: 15)),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
  static showAlertDialogCallBack1({@required BuildContext context,
    onPosClick,
    onNavClick,
    onOkClick,
    var message = 'Something went wrong',
    String posBtnName = 'YES',
    String navBtnName = 'NO',
    String okBtnName = 'OK',
    bool isConfirmationDialog = true,
    bool isOnlyOK = false}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: Text(
                StringHelper.app_name,
                style: TextStyle(
                    fontSize: 20,
                    color: ColorsHelper.themeColor,
                    fontFamily: FontsHelper.montserrat_regular,
                    fontWeight: FontWeight.bold
                ),
              ),
              content: Text(
                message,
                style: TextStyle(fontSize: 13,
                    fontFamily: FontsHelper.montserrat_regular,
                    fontWeight: FontWeight.bold),
              ),
              actions: isConfirmationDialog
                  ? isOnlyOK ?<Widget>[ FlatButton(
                onPressed: () { Navigator.of(context).pop();
                onOkClick();
                },
                child: Text(okBtnName,
                    style: TextStyle(
                        fontSize: 17,
                        color: ColorsHelper.themeColor,
                        fontFamily: FontsHelper.montserrat_regular,
                        fontWeight: FontWeight.bold)),
              )]:  <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(okBtnName,
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorsHelper.themeColor,
                          fontFamily: FontsHelper.montserrat_regular,
                          fontWeight: FontWeight.bold)),
                )
              ]
                  : <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPosClick();
                  },
                  child: Text(posBtnName,
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorsHelper.themeColor,
                          fontFamily: FontsHelper.montserrat_regular,
                          fontWeight: FontWeight.bold)),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNavClick();
                  },
                  child: Text(navBtnName,
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorsHelper.themeColor,
                          fontFamily: FontsHelper.montserrat_regular,
                          fontWeight: FontWeight.bold)),
                )
              ]);
        });
  }


  static openLink(String website) async {
    String websiteLink = website;
    if (website.substring(0, 4) != 'http') {
      websiteLink = 'http://$website';
    }
    if (await canLaunch(websiteLink)) {
      await launch(websiteLink);
    }
  }


  static call(String number) async {
    if (await canLaunch('tel:$number')) {
      await launch('tel:$number');
    }
  }




}
