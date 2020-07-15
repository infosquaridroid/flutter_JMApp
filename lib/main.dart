import 'package:jmapp/pages/Bottombar.dart';
import 'package:jmapp/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jmapp/api/api_repos.dart';
import 'package:jmapp/api/http_api.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';

import 'data_manager_inherited_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return DataManagerInheritedWidget(
        apiClient: HttpClient(),
        apiRepos: APIRepos(),
        child: new MaterialApp(

          darkTheme: ThemeData(
              primaryColor: ColorsHelper.themeColor,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              textSelectionColor: ColorsHelper.themeColor),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder(
              future: SharePreferencesHelper.getInstant()
                  .getString(SharePreferencesHelper.SHAREPREFERENCES_USER_ID),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.data);
                print(snapshot.hasData);
                if (snapshot.hasData) {
                  return snapshot.data == "" ? Login() : Bottombar();
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                  );
                }
              }),
        ));
  }
}
