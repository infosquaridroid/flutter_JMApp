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
import 'package:jmapp/pages/OrganisationDetail.dart';
import 'package:jmapp/pages/Profile.dart';
import 'package:jmapp/pages/SignupDetail.dart';
import 'package:jmapp/helpers/countryData.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class Favourite extends StatefulWidget {
  const Favourite({Key key}) : super(key: key);

  @override
  FavouriteState createState() => FavouriteState();
}

class FavouriteState extends State<Favourite>
    with AutomaticKeepAliveClientMixin {
  var arrOrganisation = [];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  String userId = "";
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var ps =
        PageStorage.of(context).readState(context, identifier: "FavouritePage");
    SharePreferencesHelper.getInstant()
        .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID)
        .then((value) {
      userId = value;
      if (ps == null) {
        getOrganisation();
      } else {
        arrOrganisation = ps["arr"];
        setState(() {});
      }
    });
  }

  void getOrganisation({bool isProgressBar = true}) async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .favouriteOrganisation(context: context, userId: userId,isProgressBar:isProgressBar );
    if (datas != null) {
      if (datas["status"] == true) {
        arrOrganisation = datas["data"];
      } else {
        arrOrganisation = [];
      }
      PageStorage.of(context).writeState(context, {'arr': arrOrganisation},
          identifier: "FavouritePage");

      setState(() {});
    }
    _refreshController.refreshCompleted();
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
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () async {
                    //monitor fetch data from network
                    getOrganisation(isProgressBar: false);
//                    await Future.delayed(Duration(milliseconds: 1000));
//
//
//                    if (mounted) setState(() {});
//                    _refreshController.refreshCompleted();

                    /*
        if(failed){
         _refreshController.refreshFailed();
        }
      */
                  },
                  onLoading: () async {
                    //monitor fetch data from network
                    await Future.delayed(Duration(milliseconds: 1000));

//    pageIndex++;
                    if (mounted) setState(() {});
                    getOrganisation();

                    _refreshController.loadComplete();
                  },
                  child: ListView.builder(
                    physics: new ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context1, int i) {
                      return Dismissible(
                          background: stackBehindDismiss(),
                          key: ObjectKey(arrOrganisation[i]),
                          child: WidgetHelper.organisationCell(
                              context: context,
                              index: i,
                              onclick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrganisationDetail(
                                            organisationId: arrOrganisation[i]
                                                ["organisation_id"],
                                          )),
                                );
                              },
                              name: arrOrganisation[i]["organisation_name"],
                              image: arrOrganisation[i]["image"],
                              city: arrOrganisation[i]["city"],
                              state: arrOrganisation[i]["state"],
                              country: arrOrganisation[i]["country"]),onDismissed: (direction){
                        setUnfavOrganisation(i);
                      },direction: DismissDirection.endToStart,);
                    },
                    itemCount: arrOrganisation.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void setUnfavOrganisation(int index) async {
    Map<String, dynamic> datas = await DataManagerInheritedWidget.of(context)
        .apiRepos
        .setFavUnfavOrganisation(
        context: context,
        userId: userId,organisationId: arrOrganisation[index]["organisation_id"],isFavourite: "0");
    if (datas != null) {
      setState(() {
        arrOrganisation.removeAt(index);
      });
      Utility.showAlertDialogCallBack(context: context,message: datas["message"]);

      setState(() {});
    }
  }
  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: ColorsHelper.themeColor,
      child: Icon(
        Icons.star,
        color: Colors.white,
      ),
    );
  }
}
