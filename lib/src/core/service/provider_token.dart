import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }
}
// class TokenManager {
//   static final TokenManager _singleton = TokenManager._internal();
//
//   factory TokenManager() {
//     return _singleton;
//   }
//
//   TokenManager._internal();
//
//   String? _token;
//
//   String? get token => _token;
//
//   void setToken(String? token) {
//     _token = token;
//   }
// }
