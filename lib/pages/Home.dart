import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/pages/Profile.dart';
import 'package:jmapp/pages/SignupDetail.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          ImageAssets.main_icon,
          width: 150,
          fit: BoxFit.contain,
        ),
        backgroundColor: ColorsHelper.themeColor,
        leading: Container(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: ListView(
            physics: new ClampingScrollPhysics(),
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}
