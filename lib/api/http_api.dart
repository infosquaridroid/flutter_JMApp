import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/utility.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

class HttpClient extends State<StatefulWidget> with TickerProviderStateMixin {
  Map<String, String> header;

  Future<http.Response> postAPI(
      {@required BuildContext context,
      bool isProgressBar,
      String urlPath,
      Map<String, dynamic> requestData,
      bool isBackground = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (isProgressBar) {
        WidgetHelper.progressBarShow(context: context, isDismissible: false);
      }
      header = await getHeader();
      Response response;
      if (requestData == null) {
        try {
          response = await http
              .post(Constants.baseOtherUri + urlPath
              )
              .timeout(new Duration(seconds: 30));
        } catch (e) {

        }
      } else {
        try {
          response = await http
              .post(Constants.baseOtherUri + urlPath,
              headers: header, body: json.encode(requestData)
          )
              .timeout(new Duration(seconds: 30));
        } catch (e) {

        }
      }
      logPrint(requestData: requestData, response: response);

      if (isProgressBar) {
        Navigator.pop(context);
      }
      if (response == null && !isBackground) {
        Utility.showAlertDialogCallBack(context: context);
        return null;
      }
      else if ((response.statusCode == 200 || response.statusCode == 201) ) {
        return response;
      } else if( !isBackground){
        Utility.showAlertDialogCallBack(context: context);
        return null;
      }
    } else if( !isBackground){
      Utility.showAlertDialogCallBack(
          context: context,
          message: StringHelper.error_msg_connection_internet);
      return null;
    }
  }

  Future<http.Response> getAPI(
      {@required BuildContext context,
      bool isProgressBar,
      String urlPath,
      bool isBackground = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (isProgressBar) {
        WidgetHelper.progressBarShow(context: context, isDismissible: false);
      }
      header = await getHeader();
      Response response;
      try {
        response = await http
            .get(Constants.baseOtherUri + urlPath
        )
            .timeout(new Duration(seconds: 30));
      } catch (e) {

      }
      logPrint(response: response);

      if (isProgressBar) {
        Navigator.pop(context);
      }
      if (response == null) {
        Utility.showAlertDialogCallBack(context: context);
        return null;
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        Utility.showAlertDialogCallBack(context: context);
        return null;
      }
    } else {
      Utility.showAlertDialogCallBack(
          context: context,
          message: StringHelper.error_msg_connection_internet);
      return null;
    }
  }

  Future<Map<String, String>> getHeader() async {
    if (header == null) {
      header = new Map<String, String>();
    } else {
      header.clear();
    }

//    final String autoToken = await SharePreferencesHelper()
//        .getString(SharePreferencesHelper.ACCESS_TOKEN);

    header['Content-Type'] = 'application/json';
//    header['Accept'] = 'application/vnd.jmapp.v1+json';
    //  header['Authorization'] = 'Bearer $autoToken';
    return header;
  }

  void logPrint({Map<String, dynamic> requestData, Response response}) {
    if (response != null) {
      debugPrint(
          '--------------------------------------------------------------');
      debugPrint(
          'request url :${response.request.method}  ${response.request.url}');
      debugPrint('request header : ${response.request.headers}');
      if (requestData != null) {
        debugPrint('request body : ${requestData.toString()}');
      }
      debugPrint(
          '--------------------------------------------------------------');
      debugPrint('response header : ${response.headers}');
      debugPrint('response statusCode : ${response.statusCode}');
      debugPrint('response body : ${response.body}');
    }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
