import 'package:diary/src/core/validator.dart';
import 'package:diary/src/dash_board.dart';
import 'package:diary/src/core/service/auth_service.dart';
import 'package:diary/src/presentation/widget/dia_log_item.dart';
import 'package:diary/src/presentation/widget/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../styles/text_app.dart';
import '../../../../styles/text_style.dart';
import '../../../bloc/bool_bloc.dart';
import '../../../core/service/provider_token.dart';
import '../SignUp/signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final BoolBloc changeState = BoolBloc();
  bool _remember = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _loadSavedData() async {
    _remember = await AuthService.getRememberMe();
    if (_remember.toString() == true.toString()) {
      String? savedUsername = await AuthService.getUsername();
      String? savedPassword = await AuthService.getPassword();
      if (savedUsername != null && savedPassword != null) {
        usernameController.text = savedUsername;
        passwordController.text = savedPassword;
      }
    } else{
      usernameController.text = '';
      passwordController.text ='';
    }
    setState(() {});
  }

  _toLogin() async {
    final username = usernameController.text;
    final password = passwordController.text;
    if (_remember = true) {
      AuthService.setUsername(username);
      AuthService.setPassword(password);
    } else {
      AuthService.setUsername('');
      AuthService.setPassword('');
    }
    final token = await authService.login(username, password);

    if (token != null) {
      Provider.of<AuthProvider>(context, listen: false).setToken(token);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const DashBoard()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
        content: Text(
          'Đăng nhập thành công.',
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
        content: Text(
            'Đăng nhập không thành công. Vui lòng kiểm tra tên đăng nhập và mật khẩu.',
            style: TextStyle(color: Colors.white)),
      ));
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _remember;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/login.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.USERNAME,
                  hintText: TextApp.userName,
                  controller: usernameController,
                  validator: (value) {
                    // return ValidatorApp.checkPhone(text: value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.PASSWORD,
                  hintText: TextApp.enterPass,
                  controller: passwordController,
                  validator: (value) {
                   // return ValidatorApp.checkPass(text: value);
                  },
                  isPass: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            BlocBuilder<BoolBloc, bool>(
                                bloc: changeState,
                                builder: (context, state) {
                                  return Checkbox(
                                      value: state,
                                      onChanged: (value) async {
                                        changeState.changeValue(value!);
                                         value = _remember;
                                        AuthService.setRememberMe(_remember);
                                      });
                                }),
                            Text(TextApp.remember,
                                style: StyleApp.textStyle400()),
                          ],
                        )),
                    Expanded(
                      child: GestureDetector(
                        child: const Text(""),
                        onTap: () {
                          if (kDebugMode) {
                            print("hello now");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () async {
                      _toLogin();
                    },
                    child: const Text('Đăng nhập'),
                  ),
                ),
                Row(
                  children: [
                    const Text("Bạn chưa có tài khoản?   "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Đăng ký ngay",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    )
                  ],
                ).paddingTop(10)
              ],
            ).paddingOnly(top: 250, left: 20, right: 20, bottom: 10),
          ),
        ),
      ),
    );
  }
}
