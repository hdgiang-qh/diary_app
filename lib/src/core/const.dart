import 'package:diary/src/core/share_pref/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'share_pref/app_key.dart';

class Const {
  static final format = NumberFormat("#,##0.##", "vi");

  static const api_host = 'http://localhost:8080/api/v1';

  static checkLogin(BuildContext context, {required Function nextPage}) async {
    bool isLogin = await SharedPrefs.readBool(AppKey.login);
    if (isLogin) {
      nextPage();
    } else {}
  }

  static formatTimeString(time, {String? format}) {
    if (time == null) {
      return "";
    }
    DateTime dateTime = DateTime.parse(time);
    return DateFormat(format ?? 'dd/MM/yyyy  HH:mm:ss', 'en_US').format(
      DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour + 7,
          dateTime.minute, dateTime.second),
    );
  }

  static formatTime(
    time, {
    String? format,
    bool isSecond = true,
  }) {
    if (time == null) {
      return "";
    }
    if (isSecond) {
      return DateFormat(format ?? 'dd/MM/yyyy  HH:mm:ss', 'en_US')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    }
    return DateFormat(format ?? 'dd/MM/yyyy  HH:mm:ss', 'en_US')
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static convertPrice(
    dynamic price,
  ) {
    var res = isNumeric(price.toString());
    if (res) {
      return format.format(double.parse(price.toString())).toString();
    }
    return "0";
  }

  static convertPhone(String? phone,
      {bool check = false, bool isHint = false}) {
    if (phone == "null" || phone == "" || phone == null) {
      if (check) {
        return "";
      }
      return "Chưa cập nhật";
    }

    if (isHint) {
      return "${phone.substring(0, 4)}***${phone.substring(7, phone.length)}";
    }

    return "${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7, 10)}";
  }

  static convertContact(
    String? value,
  ) {
    if (value != null) {
      String data = value.replaceAll(" ", '');
      String data1 = data.replaceAll("-", '');
      String data2 = data1.replaceAll("+", '');
      if (data2.startsWith("84")) {
        return "0${data2.substring(2, data2.length)}";
      }
      return data2;
    }
    return "";
  }

  static String convertDateFormatNew(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
    return formattedDate;
  }

  static double convertNumber(dynamic data) {
    var res = isNumeric(data.toString());
    if (res) {
      return double.parse(data.toString());
    }
    return 0;
  }

  static bool isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  static callLaunch(url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
extension ToStringTime on DateTime {
  String toDateTimeString() {
    return " $year-${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00";
  }

  String toDateTimeStringWithoutHour() {
    return " ${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ";
  }
}