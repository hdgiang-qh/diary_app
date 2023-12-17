import 'package:flutter/material.dart';

class NavUtils {
  static Future navigatePage(BuildContext context, Widget widget) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => widget));
  }

  static void pop(BuildContext context, {dynamic result}) {
    return Navigator.of(context).pop(result);
  }

  static Future navigatePageAndReplace(BuildContext context, Widget widget) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }
}
