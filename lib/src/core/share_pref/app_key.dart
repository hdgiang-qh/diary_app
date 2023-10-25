import 'share_pref.dart';

class AppKey {
  static const login = "login";
  //user
  static const user = "user";
  static const userId = "user-id";
  static const userToken = "user-token";
  static const userCode = "referral-code";
  static const userPhone = "user-phone";
  static const userEmail = "user-email";
  static const userName = "user-name";
  static const userAvatar = "user-avatar";
  static const userAddress = 'user-address';
  static const gender = 'gender';

  static logout() async {
    await SharedPrefs.remove(AppKey.login);
    await SharedPrefs.remove(AppKey.user);
    await SharedPrefs.remove(AppKey.userId);
    await SharedPrefs.remove(AppKey.userToken);
    await SharedPrefs.remove(AppKey.userPhone);
    await SharedPrefs.remove(AppKey.userCode);
    await SharedPrefs.remove(AppKey.userEmail);
    await SharedPrefs.remove(AppKey.userName);
    await  SharedPrefs.remove(AppKey.userAvatar);
    await SharedPrefs.remove(AppKey.userAddress);
    await SharedPrefs.remove(AppKey.gender);
  }
}
