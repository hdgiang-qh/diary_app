import 'package:diary/src/dash_board.dart';
import 'package:diary/src/presentation/Auth/SignUp/signup_screen.dart';
import 'package:diary/src/presentation/widget/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

import '../styles/text_app.dart';
import '../styles/text_style.dart';
import 'bloc/bool_bloc.dart';
import 'core/validator.dart';

class LoginEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);
}

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final Map<String, dynamic> userData;

  LoginSuccessState(this.userData);
}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}

class LoginCubit extends Cubit<LoginState> {
  final Dio dio = Dio();

  LoginCubit() : super(LoginInitialState());

  void login(String username, String password) async {
    emit(LoginLoadingState());

    try {
      final response = await dio
          .post('http://localhost:8080/api/v1/authenticate/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final userData = response.data;
        emit(LoginSuccessState(userData));
      } else {
        emit(LoginErrorState('Đăng nhập thất bại'));
      }
    } catch (e) {
      emit(LoginErrorState('Lỗi đăng nhập: $e'));
    }
  }
}

class MyAppNew extends StatefulWidget {
  @override
  State<MyAppNew> createState() => _MyAppNewState();
}

class _MyAppNewState extends State<MyAppNew> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final BoolBloc changeState = BoolBloc();

  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    textFieldType: TextFieldType.USERNAME,
                    hintText: TextApp.enterPhone,
                    controller: usernameController,
                    validator: (value) {
                      return ValidatorApp.checkPhone(text: value);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    textFieldType: TextFieldType.PASSWORD,
                    hintText: TextApp.enterPass,
                    controller: passwordController,
                    validator: (value) {
                      return ValidatorApp.checkPass(text: value);
                    },
                    isPass: true,
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    final username = usernameController.text;
                    final password = passwordController.text;
                    context.read<LoginCubit>().login(username, password);
                  },
                  child: const Text(
                    'Đăng nhập',
                  ),
                ),
              ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoadingState) {
                    return const CircularProgressIndicator();
                  } else if (state is LoginSuccessState) {
                    return const Text('Đăng nhập thành công');
                  } else if (state is LoginErrorState) {
                    // Xử lý lỗi đăng nhập
                    return const Text(
                      'Tài khoản hoặc Mật khẩu không đúng',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
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
              ).paddingTop(10),
            ],
          ).paddingOnly(top: 250, left: 20, right: 20, bottom: 10),
        ),
      ),
    );
  }
}
