import 'package:diary/styles/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../styles/text_app.dart';
import '../../../bloc/bool_bloc.dart';
import '../../../dash_board.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final BoolBloc changeState = BoolBloc();
  TextEditingController numberPhone = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool remember = false;
  late bool showPass;

  @override
  void initState() {
    super.initState();
    showPass = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Welcome to App"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Phone").paddingLeft(5),
                TextField(
                  controller: numberPhone,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                      prefixIcon: const Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.phone_android_outlined,
                        ),
                      ),
                      hintText: 'Enter your phone...',
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Password").paddingLeft(5),
                TextField(
                  controller: passWord,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  obscureText: showPass,
                  decoration: InputDecoration(
                      prefixIcon: const Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.lock_outline,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        icon: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      hintText: 'Enter your password...',
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
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
                                    remember = value;
                                  });
                            }),
                        Text(TextApp.remember, style: StyleApp.textStyle400()),
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
            ).paddingTop(5),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashBoard()));
                  },
                  child: const Text('Sign in new a gen')),
            ),
            Row(
              children: [
                const Text("Do not have an account?   "),
                GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print("Sign Up");
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              ],
            ).paddingTop(10)
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}
