
import 'package:diary/src/dash_board.dart';
import 'package:diary/src/core/service/auth_service.dart';
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

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final BoolBloc changeState = BoolBloc();
  bool remember = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final error = authService.error;
    return Container(
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
                hintText: TextApp.enterPhone,
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
                                      remember = value;
                                    });
                              }),
                          Text(TextApp.remember,
                              style: StyleApp.textStyle400()),
                        ],
                      )),
                  Expanded(
                    child: GestureDetector(
                      child: const Text("Forgot Password"),
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
                    final username = usernameController.text;
                    final password = passwordController.text;

                    final token = await authService.login(username, password);

                    if (token != null) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .setToken(token);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DashBoard()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text('Đăng nhập thành công.'),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                                  content: Text('Đăng nhập không thành công. Vui lòng kiểm tra tên đăng nhập và mật khẩu.'),
                                ));
                    }
                    if (kDebugMode) {
                      print("Token : $token");
                    }
                  },
                  child: const Text('Đăng nhập'),
                ),
              ),
              Row(
                children: [
                  const Text("Do not have an account?   "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogUpScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  )
                ],
              ).paddingTop(10)
            ],
          ).paddingOnly(top: 250, left: 20, right: 20, bottom: 10),
        ),
      ),
    );
  }
}

