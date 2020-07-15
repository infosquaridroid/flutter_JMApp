import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jmapp/data_manager_inherited_widget.dart';
import 'package:path_provider/path_provider.dart';

class APIRepos {


  Future<Map<String, dynamic>> sendOtp({BuildContext context,bool isProgressBar = true,bool isBackground = false,String country_code = "",String mobile = ""}) async {
    http.Response response = await DataManagerInheritedWidget.of(context)
        .apiClient
        .postAPI(
        context: context,
        isProgressBar: isProgressBar,isBackground: isBackground,
        urlPath: '/index/sendotp',requestData: {"country_code":country_code,"mobile":mobile});

    return (response != null) ? json.decode(response.body) : null;
  }
  Future<Map<String, dynamic>> signup({BuildContext context,bool isProgressBar = true,bool isBackground = false,String country_code = "",String email = "",String first_name = "",String last_name = "",String mobile = ""}) async {
    http.Response response = await DataManagerInheritedWidget.of(context)
        .apiClient
        .postAPI(
        context: context,
        isProgressBar: isProgressBar,isBackground: isBackground,
        urlPath: '/index/userregister',requestData: {"email":email,"first_name":first_name,"last_name":last_name,"mobile":mobile,"country_code":country_code});

    return (response != null) ? json.decode(response.body) : null;
  }
  Future<Map<String, dynamic>> getUserDetail({BuildContext context,bool isProgressBar = true,bool isBackground = false,String user_id = ""}) async {
    http.Response response = await DataManagerInheritedWidget.of(context)
        .apiClient
        .postAPI(
        context: context,
        isProgressBar: isProgressBar,isBackground: isBackground,
        urlPath: '/index/getuserdetail',requestData: {"user_id":user_id});

    return (response != null) ? json.decode(response.body) : null;
  }
  Future<Map<String, dynamic>> updateUserDetail({BuildContext context,bool isProgressBar = true,bool isBackground = false,String user_id = "",String address = "",String city = "",String state = "",String postcode = "",String country = "",String first_name = "",String last_name = "",String email = "",String role = "",String time_zone = ""}) async {
    http.Response response = await DataManagerInheritedWidget.of(context)
        .apiClient
        .postAPI(
        context: context,
        isProgressBar: isProgressBar,isBackground: isBackground,
        urlPath: '/index/profileupdate',requestData: {"user_id":user_id,"address":address,"city":city,"state":state,"postcode":postcode,"country":country,"first_name":first_name,"last_name":last_name,"email":email,"role":role,"time_zone":time_zone});

    return (response != null) ? json.decode(response.body) : null;
  }
  Future<Map<String, dynamic>> lastLogin({BuildContext context,bool isProgressBar = true,bool isBackground = false,String user_id = ""}) async {
    http.Response response = await DataManagerInheritedWidget.of(context)
        .apiClient
        .postAPI(
        context: context,
        isProgressBar: isProgressBar,isBackground: isBackground,
        urlPath: '/index/lastlogin',requestData: {"user_id":user_id});

    return (response != null) ? json.decode(response.body) : null;
  }
  Future<Map<String, dynamic>> updateMobile({BuildContext context,bool isProgressBar = true,bool isBackground = false,String country_code = "",String mobile = "",String userId = ""}) async {
    http.Response response = await DataManagerInheritedWidget.of(context)
        .apiClient
        .postAPI(
        context: context,
        isProgressBar: isProgressBar,isBackground: isBackground,
        urlPath: '/index/updatemobile',requestData: {"country_code":country_code,"mobile":mobile,"user_id":userId});

    return (response != null) ? json.decode(response.body) : null;
  }
}
