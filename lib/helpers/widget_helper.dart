import 'package:flutter/cupertino.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:flutter/material.dart';

class WidgetHelper {
  static progressBarShow({BuildContext context, bool isDismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (_) => new WillPopScope(
          child: new SimpleDialog(
            contentPadding: EdgeInsets.all(10.0),
            shape: CircleBorder(),
            backgroundColor: ColorsHelper.themeColor,
            children: [
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
          onWillPop: () {
            return Future.value(isDismissible);
          }),
    );
  }
}


