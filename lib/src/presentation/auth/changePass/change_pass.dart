import 'package:diary/src/bloc/auth_bloc/changePass/change_pass_bloc.dart';
import 'package:diary/src/core/service/auth_service.dart';
import 'package:diary/styles/text_app.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late final ChangePassBloc _bloc;
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController newPassAgain = TextEditingController();
  final AuthService authService = AuthService();
  String? savePass, errorOldPass, errorNewPass, errorNewPassAgain;
  bool hideShowPass = true;

  @override
  void initState() {
    navigatorPass();
    super.initState();
    _bloc = ChangePassBloc();
  }

  void toastFailure(String messenger) => Fluttertoast.showToast(
      msg: "Hãy nhập đầy đủ thông tin",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void toastSuccess(String messenger) => Fluttertoast.showToast(
      msg: "Cập nhật mật khẩu thành công",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void navigatorPass() async {
    String? savedPassword = await AuthService.getPassword();
    savePass = savedPassword.validate();
  }

  void changePassword() {
    if ((oldPass.text.isEmpty ||
            newPass.text.isEmpty ||
            newPassAgain.text.isEmpty) &&
        oldPass.text == savePass) {
      errorOldPass = null;
      toastFailure("");
      Navigator.of(context).pop();
    } else if (oldPass.text != savePass) {
      errorOldPass = "Mật khẩu cũ không đúng";
      Navigator.of(context).pop();
    } else if (oldPass.text == savePass) {
      errorOldPass = null;
      if (newPass.text == savePass) {
        errorNewPass = "Mật khẩu mới phải khác mật khẩu cũ";
      } else if (newPassAgain.text != newPass.text) {
        errorNewPass = null;
        errorNewPassAgain = "Mật khẩu mới không khớp";
      } else {
        errorNewPassAgain = null;
        EasyLoading.show();
        Future.delayed(const Duration(milliseconds: 1000), () {
           AuthService.setPassword(newPass.text.toString());
          _bloc.changePass();
        })
            .then((value) => EasyLoading.dismiss())
            .then((value) => toastSuccess(""))
            .then((value) => Navigator.of(context).pop());
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    oldPass = _bloc.oldp;
    newPass = _bloc.np;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 35, top: 30, bottom: 30),
                      child: const Text(
                        TextApp.changePass,
                        style: TextStyle(color: Colors.white, fontSize: 33),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: oldPass,
                            obscureText: hideShowPass,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                errorText: errorOldPass,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                labelText: "Nhập mật khẩu cũ",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: newPass,
                            obscureText: hideShowPass,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                helperText: "Mật khẩu phải hơn 6 ký tự",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                errorText: errorNewPass,
                                labelText: "Mật khẩu mới",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: newPassAgain,
                            obscureText: hideShowPass,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                errorText: errorNewPassAgain,
                                labelText: "Nhập lật khẩu mới",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              hideShowPass
                                  ? const Text('Hiện mật khẩu')
                                  : const Text("Ẩn mật khẩu"),
                              IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      hideShowPass = !hideShowPass;
                                    },
                                  );
                                },
                                icon: Icon(hideShowPass
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    // print(savePass);
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: const Icon(
                                                    CupertinoIcons.info_circle),
                                                content: const Text(
                                                  'Do you want to change Password?',
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Huỷ",
                                                        style: StyleApp
                                                            .textStyle402()),
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () async {
                                                      changePassword();
                                                      setState(() {});
                                                    },
                                                    child: Text("Đồng ý",
                                                        style: StyleApp
                                                            .textStyle401()),
                                                  ),
                                                ],
                                              );
                                            });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
