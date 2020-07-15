import 'package:jmapp/helpers/strings.dart';

class CommonValidator {
  static String mobileNumValidationWithEmpty(String value) {
    if (value.isEmpty) {
      return StringHelper.error_msg_empty_mobile;
    } else if (value.length < 10) {
      return StringHelper.error_msg_invalid_mobile_10_digits;
    } else if (value.length > 10) {
      return StringHelper.error_msg_invalid_mobile_10_digits;
    } else {
      return null;
    }
  }

  static String mobileNumValidation(String value) {
    if(value.isNotEmpty) {
      if (value.length < 10) {
        return StringHelper.error_msg_invalid_mobile_10_digits;
      } else if (value.length > 10) {
        return StringHelper.error_msg_invalid_mobile_10_digits;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String passValidation(String value) {
    if (value.isEmpty) {
      return StringHelper.error_msg_empty_pass;
    } else if (value.length < 6) {
      return StringHelper.error_msg_min_length;
    } else {
      return null;
    }
  }

  static String otpValidation(String value) {
    if (value.isEmpty) {
      return StringHelper.error_msg_empty_otp;
    } else if (value.length < 4) {
      return StringHelper.error_msg_invalid_otp;
    } else {
      return null;
    }
  }

  static String emailValidation(String value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    if (value.isEmpty) {
      return StringHelper.error_msg_empty_email;
    } else if (!(new RegExp(p).hasMatch(value))) {
      return StringHelper.error_msg_invalid_email;
    } else {
      return null;
    }
  }


}
