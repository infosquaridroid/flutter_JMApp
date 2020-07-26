import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/pages/Home.dart';
import 'package:jmapp/pages/Login.dart';
import 'package:jmapp/pages/Profile.dart';
import 'package:jmapp/pages/SignupDetail.dart';

class Menu extends StatefulWidget {

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: ColorsHelper.headerColor,
        leading: Container(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,color: ColorsHelper.bodyColor,
        child: SafeArea(
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
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Profile()),
                  );
                },
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      ImageAssets.user,
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(
                      width: 15,
                      height: 45,
                    ),
                    Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: ColorsHelper.themeColor),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Image.asset(
                      ImageAssets.rdd,
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              )),
              Container(
                height: 1,
                color: Colors.black45,
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          ImageAssets.payment,
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 15,
                          height: 45,
                        ),
                        Expanded(
                          child: Text(
                            'Payment methods',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: ColorsHelper.themeColor),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Image.asset(
                          ImageAssets.rdd,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  )),

              Container(
                height: 1,
                color: Colors.black45,
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          ImageAssets.security,
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 15,
                          height: 45,
                        ),
                        Expanded(
                          child: Text(
                            'Security',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: ColorsHelper.themeColor),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Image.asset(
                          ImageAssets.rdd,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  )),

              Container(
                height: 1,
                color: Colors.black45,
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          ImageAssets.question,
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 15,
                          height: 45,
                        ),
                        Expanded(
                          child: Text(
                            'Support',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: ColorsHelper.themeColor),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Image.asset(
                          ImageAssets.rdd,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  )),
              Container(
                height: 1,
                color: Colors.black45,
              ),
SizedBox(height: 50,),
              Container(
                height: 1,
                color: Colors.black45,
              ),
              InkWell(onTap: (){
//                SharePreferencesHelper.getInstant().removePref(SharePreferencesHelper.SHAREPREFERENCES_USER_ID);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login()),
                );
              },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(
                          height: 45,
                        ),
                        Text(
                          'Lock',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: ColorsHelper.themeColor),
                        ),

                      ],
                    ),
                  )),
              Container(
                height: 1,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
