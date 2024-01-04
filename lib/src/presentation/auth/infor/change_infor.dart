import 'package:diary/src/bloc/SignIn-SignUp/sign_up_bloc/sign_up_bloc.dart';
import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_app.dart';
import 'package:diary/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangeInforScreen extends StatefulWidget {
  const ChangeInforScreen({Key? key}) : super(key: key);

  @override
  State<ChangeInforScreen> createState() => _ChangeInforScreenState();
}

class _ChangeInforScreenState extends State<ChangeInforScreen> {
  late final InforBloc _bloc;
  TextEditingController numberPhone = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController date = TextEditingController();
  String? ErrorPhone;
  bool passwordVisible = true;

  @override
  void initState() {
    _bloc = InforBloc();
    _bloc.getInforUser();
    super.initState();
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

  void save(){

  }
  Widget changeInfor() {
    _bloc.phone = numberPhone;
    _bloc.nickName = nickName;
    _bloc.email = email;
    _bloc.date = date;
    return BlocBuilder<InforBloc, InforState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is InforFailure) {
            return Center(
              child: Text(state.error.toString()),
            );
          } else if (state is InforSuccess2) {
            numberPhone.text = _bloc.ifUser!.phone.validate().toString();
            nickName.text = _bloc.ifUser!.nickName.validate().toString();
            email.text = _bloc.ifUser!.email.validate().toString();
            date.text = _bloc.ifUser!.date.validate().toString();
            return Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 35, top: 00, bottom: 20),
                    child: const Text(
                      TextApp.changeInfor,
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
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
                          controller: date,
                          style:
                              const TextStyle(color: Colors.white, height: 1),
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () async {
                                  date.text = '';
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
                                icon: const Icon(Icons.calendar_month_outlined),
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
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Xác nhận thay đổi',
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
                                    if (nickName.text.isNotEmpty &&
                                        numberPhone.text.isNotEmpty &&
                                        email.text.isNotEmpty &&
                                        date.text.isNotEmpty) {
                                      if (numberPhone.text.length == 10) {
                                        ErrorPhone = null;
                                        _bloc.updateInfor();
                                        NavUtils.pop(context,
                                            result: true);
                                      } else {
                                        ErrorPhone =
                                        "Số điện thoại phải đúng định dạng (10 số)";
                                      }
                                    } else {
                                      toastError("");
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
                                  backgroundColor: ColorAppStyle.button),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
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
            SingleChildScrollView(child: changeInfor()),
          ],
        ),
      ),
    );
  }
}
