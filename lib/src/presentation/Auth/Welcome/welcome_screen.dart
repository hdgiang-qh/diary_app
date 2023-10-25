import 'package:diary/src/bloc/auth_bloc/login_cubit.dart';
import 'package:diary/src/bloc/check_state.dart';
import 'package:diary/src/bloc/cubit_state.dart';
import 'package:diary/src/core/validator.dart';
import 'package:diary/src/presentation/widget/text_field.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../styles/text_app.dart';
import '../../../bloc/bool_bloc.dart';
import '../../../dash_board.dart';
import '../SignUp/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final BoolBloc changeState = BoolBloc();
  TextEditingController numberPhone = TextEditingController();
  TextEditingController passWord = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final LoginCubit login = LoginCubit();
  bool _remember = false;
  late bool showPass;

  @override
  void initState() {
    super.initState();
    showPass = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _globalKey,
            child: Column(
              children: [
                const Text(
                  "Welcome to App",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      textFieldType: TextFieldType.PHONE,
                      hintText: TextApp.enterPhone,
                      controller: numberPhone,
                      validator: (value) {
                        return ValidatorApp.checkPhone(text: value);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      hintText: TextApp.enterPass,
                      controller: passWord,
                      validator: (value) {
                        return ValidatorApp.checkPass(text: value);
                      },
                      isPass: true,
                    ),
                  ],
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
                                        _remember = value;
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
                BlocListener(
                  bloc: login,
                  listener: (context, CubitState state) {
                    CheckState.check(context, state, success: () {
                      const DashBoard().launch(context);
                    });
                  },
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () {
                          toLogin();
                        },
                        child: const Text(
                          'Sign in new a gen',
                          style: TextStyle(color: Colors.cyan),
                        )),
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
      ),
    );
  }

  void toLogin() {
    if (_globalKey.currentState!.validate()) {
      login.login(
        phone: numberPhone.text,
        pass: passWord.text,
        remember: _remember,
      );
    } else {}
  }
}
