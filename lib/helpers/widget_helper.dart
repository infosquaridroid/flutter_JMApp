import 'package:flutter/cupertino.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinTextFieldFocus extends StatefulWidget {

  Function save;
  Function onCompleted;
  bool autoFocus;
  TextEditingController controller;
  TextStyle txtStyle;
  FocusNode focus;
  Function rightBtnClick;
  PinTextFieldFocus(
      {Key key,
        this.controller,
        this.save,this.txtStyle,this.onCompleted,this.autoFocus = false,this.focus})
      : super(key: key);
  @override
  _PinTextFieldFocusState createState() => new _PinTextFieldFocusState();
}

class _PinTextFieldFocusState extends State<PinTextFieldFocus> {

  bool active = false;
  @override
  void initState() {
    super.initState();
    widget.focus = widget.focus == null ? FocusNode() : widget.focus;
    widget.focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    active = widget.focus.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        PinCodeTextField(
          textInputType: TextInputType.numberWithOptions(),
          textStyle: widget.txtStyle,
          backgroundColor: Colors.transparent,
          inactiveColor: Colors.black,
          activeColor:Colors.black ,
          selectedColor: ColorsHelper.themeColor,
          inactiveFillColor: Colors.black,
          activeFillColor: Colors.black,
          selectedFillColor: ColorsHelper.themeColor,
          length: 6,
          obsecureText: false,
          animationType: AnimationType.fade,
          animationDuration: Duration(milliseconds: 300),
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 40,
          fieldWidth: 40,
          controller: widget.controller,focusNode: widget.focus,
          onChanged: widget.save,onCompleted:widget.onCompleted ,autoFocus: widget.autoFocus,
        ),
      ],
    );
  }
}
class WidgetHelper {
  static organisationCell ({BuildContext context,index, name="",image="",city="",state="",country="",onclick})
  {
    return  InkWell(
      onTap: onclick,
      child: Container(
        child: Column(
          children: <Widget>[
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
                        image: image,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        Text(
                          city +
                              (state != ""
                                  ? ", "
                                  : "") +
                             state +
                              (country !=
                                  ""
                                  ? ", "
                                  : "") +
                              country,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    ImageAssets.rdd,
                    width: 16,
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
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


