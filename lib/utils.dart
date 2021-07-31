import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const APP_ID = 'e7d3be2abaf54f8cbe2a329271388a26';
const Token =
    '006e7d3be2abaf54f8cbe2a329271388a26IABjm5vCpXMe3uUHqLXUl7VGMOh7rVuP5c8UgtVBSG1G73ZXrgMAAAAAEADUr3TTYuX+YAEAAQAAAAAA';

class Utils {
  static final channelId = 'testChannel';

  static Future<String> getTokenUrl(var name) async {
    return 'https://agoratokenbig.herokuapp.com/access_token?channel=${name.toString()}';
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
