import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_app.dart';
import 'package:diary/styles/text_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();

  Future<void> changePass() async {
    final oldp = oldPass.text;
    final np = newPass.text;
    try {
      final res = await Api.getAsync(
        endPoint: "${ApiPath.changePass}?oldPassword=$oldp&password=$np",
      );
      if (oldp.isEmpty || np.isEmpty || np == oldp) {
        return;
      } else if (res['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Change Success!'),
        ));
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Old Pass Wrong!!'),
      ));
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
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
                                backgroundColor:  const Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white, onPressed: () { Navigator.of(context)
                                    .pop(); }, icon: const Icon(Icons.arrow_back),
                                  
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
                                                      changePass();
                                                      oldPass.clear();
                                                      newPass.clear();
                                                      const CircularProgressIndicator();
                                                      Navigator.of(context)
                                                          .pop();
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
