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
import 'package:jmapp/pages/Profile.dart';
import 'package:jmapp/pages/SignupDetail.dart';
import 'package:jmapp/helpers/countryData.dart';

class OrganisationDetail extends StatefulWidget {
  String organisationId;
  OrganisationDetail({Key key, this.organisationId}) : super(key: key);
  @override
  OrganisationDetailState createState() => OrganisationDetailState();
}

class OrganisationDetailState extends State<OrganisationDetail> {
  String userId = "";
var organisationDetail = null;
String isFavorite = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID)
        .then((value) {
      userId = value;
      getOrganisationDetail();
    });
  }

  void getOrganisationDetail() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .getOrganisationDetail(
        context: context,
        userId: userId,organisationId: widget.organisationId);
    if (datas != null) {
      if (datas["status"] == true) {
        organisationDetail = datas["data"];
        isFavorite = organisationDetail["favorite"] != null ? organisationDetail["favorite"] : "0";
      }
      setState(() {});
    }
  }
  void setFavUnfavOrganisation() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .setFavUnfavOrganisation(
        context: context,
        userId: userId,organisationId: widget.organisationId,isFavourite: isFavorite == "0" ? "1" : "0");
    if (datas != null) {
      if (datas["status"] == true) {

        isFavorite = isFavorite == "0" ? "1" : "0";
      }

      Utility.showAlertDialogCallBack(context: context,message: datas["message"]);

      setState(() {});
    }
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

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorsHelper.bodyColor,
        child: SafeArea(
          child: organisationDetail == null ? Container() : ListView(
            physics: new ClampingScrollPhysics(),
            children: <Widget>[
              SizedBox(height: 5,),

              Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 0.5,
                              color: Colors.black,
                              style: BorderStyle.solid)),
                      child: ClipRRect(
//                      borderRadius: BorderRadius.circular(20.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: ImageAssets.placeholder,
                          image: organisationDetail["image"],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        organisationDetail["name"] ,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ),
//                    Expanded(
//                      child: Column(
//                        mainAxisAlignment:
//                        MainAxisAlignment.center,
//                        crossAxisAlignment:
//                        CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            organisationDetail["name"],
//                            style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 15),
//                          ),
//                          Text(
//                            organisationDetail != null ? (organisationDetail["city"]  +
//                                ( organisationDetail["state"] != ""
//                                    ? ", "
//                                    : "") +
//                                organisationDetail["state"] +
//                                ( organisationDetail["country"] !=
//                                    ""
//                                    ? ", "
//                                    : "") +
//                                organisationDetail["country"]) : "",
//                            style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 15),
//                          ),
//                        ],
//                      ),
//                    ),
                    InkWell(onTap: (){
setFavUnfavOrganisation();
                    },
                      child: Image.asset(
                       isFavorite == "0" ? ImageAssets.unfav : ImageAssets.fav,
                        width: 50,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20,top: 10),
                child: Text(organisationDetail["description"] ,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20,top: 20),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Container(width:70,
                    child: Text("Address",
                      style: TextStyle(
                          color: Colors.black,fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),Text(": ",
                    style: TextStyle(
                        color: Colors.black,fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                    Expanded(
                      child: Text(organisationDetail["street"]  +
                          ( organisationDetail["city"] != ""
                              ? ", "
                              : "") +
                          organisationDetail["city"] +
                          ( organisationDetail["state"] != ""
                              ? ", "
                              : "") +
                            organisationDetail["state"] +
                          ( organisationDetail["country"] !=
                              ""
                              ? ", "
                              : "") +
                          organisationDetail["country"]+
                          ( organisationDetail["postcode"] !=
                              ""
                              ? ", "
                              : "") +
                          organisationDetail["postcode"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15),maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20,top: 5),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Container(width:70,
                    child: Text("Email",
                      style: TextStyle(
                          color: Colors.black,fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),

                  ),Text(": ",
                    style: TextStyle(
                        color: Colors.black,fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                    Expanded(
                      child: Text(organisationDetail["email"] ,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15),maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20,top: 5),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Container(width:70,
                    child: Text("Mobile",
                      style: TextStyle(
                          color: Colors.black,fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),Text(": ",
                    style: TextStyle(
                        color: Colors.black,fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                    Expanded(
                      child: Text(organisationDetail["mobile"] ,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15),maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {


                    },
                    child: Container(
                      width: 150,
                      child: Center(
                        child: Text(
                          "Pay",
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
                ],
              ),              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}
