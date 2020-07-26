import 'package:jmapp/data_manager_inherited_widget.dart';
import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/pages/OrganisationDetail.dart';
import 'package:jmapp/pages/Profile.dart';
import 'package:jmapp/pages/SignupDetail.dart';
import 'package:jmapp/helpers/countryData.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  TextEditingController txtSearch = TextEditingController();
  FocusNode fnSearch = FocusNode();
  var arrOrganisation = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      fnSearch.nextFocus();
    });
  }



  void getOrganisation() async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .searchOrganisation(
            context: context,
            keyword: txtSearch.text,
            isBackground: true,
            isProgressBar: false);
    if (datas != null) {
      print(datas);
      if (datas["status"] == true) {
        arrOrganisation = datas["data"];
      } else {
        arrOrganisation = [];
      }
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
        leading: Container(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorsHelper.bodyColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 15),
                child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 10),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (s) {
                            getOrganisation();
                          },
                          style: TextStyle(fontWeight: FontWeight.w500),
                          focusNode: fnSearch,
                          cursorColor: ColorsHelper.themeColor,
                          controller: txtSearch,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Search"),
                        ),
                      ),
                    ],
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
              Expanded(
                child: ListView.builder(
                  physics: new ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context1, int i) {
                    return WidgetHelper.organisationCell(context: context,index: i,onclick: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrganisationDetail(organisationId:arrOrganisation[i]["id"] ,
                            )),
                      );
                    },name: arrOrganisation[i]["name"],image: arrOrganisation[i]["image"],city: arrOrganisation[i]["city"],state: arrOrganisation[i]["state"],country: arrOrganisation[i]["country"]);
                  },
                  itemCount: arrOrganisation.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
