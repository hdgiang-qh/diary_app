import 'package:diary/src/bloc/SignIn-SignUp/sign_up_bloc/sign_up_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpBloc _bloc;
  TextEditingController numberPhone = TextEditingController();
  TextEditingController passWord = TextEditingController();
  TextEditingController nameUser = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController email = TextEditingController();
  String? ErrorPass, ErrorPhone;
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _bloc = SignUpBloc();
  }

  void toastComplete(String messenger) => Fluttertoast.showToast(
      msg: "Đăng ký thành công",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white);

  void toastError(String messenger) => Fluttertoast.showToast(
      msg: "Hãy nhập đầy đủ thông tin",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white);

  @override
  Widget build(BuildContext context) {
    date = _bloc.date;
    numberPhone = _bloc.phone;
    nameUser = _bloc.username;
    passWord = _bloc.password;
    nickName = _bloc.nickName;
    email = _bloc.email;
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
                      const EdgeInsets.only(left: 35, top: 00, bottom: 20),
                      child: const Text(
                        TextApp.createAccount,
                        style: TextStyle(color: Colors.white, fontSize: 33),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Tên đăng nhập viết liền không dấu",
                                style: TextStyle(fontSize: 10),
                              )).paddingOnly(right: 5, bottom : 2),
                          TextField(
                            controller: nameUser,
                            style: const TextStyle(
                              color: Colors.white,
                              height: 1,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person_2_outlined),
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
                                label: const Text("Tên đăng nhập"),
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: passWord,
                            style:
                            const TextStyle(color: Colors.white, height: 1),
                            obscureText: passwordVisible,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                          () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                                errorText: ErrorPass,
                                prefixIcon: const Icon(Icons.lock_outline),
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
                                label: const Text("Mật khẩu"),
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            keyboardType: TextInputType.phone,
                            controller: numberPhone,
                            style:
                            const TextStyle(color: Colors.white, height: 1),
                            decoration: InputDecoration(
                                errorText: ErrorPhone,
                                prefixIcon:
                                const Icon(Icons.phone_android_outlined),
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
                                label: const Text("Điện thoại"),
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: email,
                            style:
                            const TextStyle(color: Colors.white, height: 1),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.alternate_email),
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
                                label: const Text("Email"),
                                hintStyle: const TextStyle(
                                    color: Colors.white, height: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: nickName,
                            style:
                            const TextStyle(color: Colors.white, height: 1),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person_3_outlined),
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
                                label: const Text("Tên người dùng"),
                                hintStyle: const TextStyle(
                                    color: Colors.white, height: 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: date,
                            style:
                            const TextStyle(color: Colors.white, height: 1),
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  onPressed: () async {
                                    late final formatter =
                                    DateFormat('yyyy-MM-dd');
                                    DateTime? picker = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025));
                                    setState(() {
                                      date.text = formatter.format(picker!);
                                    });
                                  },
                                  icon:
                                  const Icon(Icons.calendar_month_outlined),
                                ),
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
                                label: const Text("Ngày sinh"),
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Đăng ký mới',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (passWord.text.length > 5 &&
                                          numberPhone.text.length == 10) {
                                        ErrorPass = null;
                                        ErrorPhone = null;
                                        if (_bloc.nickName.text.isNotEmpty &&
                                            _bloc.password.text.isNotEmpty &&
                                            _bloc.username.text.isNotEmpty &&
                                            _bloc.date.text.isNotEmpty &&
                                            _bloc.phone.text.isNotEmpty &&
                                            _bloc.email.text.isNotEmpty) {
                                          _bloc.register();
                                          toastComplete("");
                                          Navigator.pop(context);
                                        } else {
                                          toastError("");
                                        }
                                      } else if (passWord.text.length < 6 &&
                                          numberPhone.text.length == 10) {
                                        ErrorPass =
                                        "Mật khẩu phải dài hơn 6 kí tự";
                                        ErrorPhone = null;
                                      } else if (passWord.text.length > 5 &&
                                          numberPhone.text.length != 10) {
                                        ErrorPass = null;
                                        ErrorPhone =
                                        "Số điện thoại phải đúng định dạng";
                                      } else if (passWord.text.length < 6 &&
                                          numberPhone.text.length != 10) {
                                        ErrorPass =
                                        "Mật khẩu phải dài hơn 6 kí tự";
                                        ErrorPhone =
                                        "Số điện thoại phải đúng định dạng";
                                      }
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorAppStyle.button
                                ),
                                child: const Text(
                                  'Đăng nhập',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          )
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