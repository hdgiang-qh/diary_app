import 'package:diary/src/bloc/auth_bloc/changePass/change_pass_bloc.dart';
import 'package:diary/styles/text_app.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late final ChangePassBloc _bloc;
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();


  @override
  void initState() {
    super.initState();
    _bloc = ChangePassBloc();
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
                                hintText: "Old Pass",
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
                                hintText: "New Pass",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
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
                                                    onPressed: () {
                                                      if (_bloc.oldp.text
                                                                  .isNotEmpty &&
                                                              _bloc.np.text
                                                                  .isNotEmpty &&
                                                          _bloc.oldp.text !=
                                                              _bloc.np.text){
                                                        _bloc.changePass();
                                                        Navigator.pop(context);
                                                        newPass.clear();
                                                        oldPass.clear();
                                                      }
                                                      else{
                                                        print("Not Value");
                                                        Navigator.pop(context);
                                                      }

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
