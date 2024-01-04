import 'dart:io';

import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({super.key});

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
  late final InforBloc _bloc;
  XFile? image;

  @override
  void initState() {
    super.initState();
    _bloc = InforBloc();
  }

  void toastEditComplete(String messenger) => Fluttertoast.showToast(
      msg: "Cập nhật thành công",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.button,
        automaticallyImplyLeading: false,
        title: const Text("Chọn avatar"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.app5,
                ColorAppStyle.app6,
                ColorAppStyle.app2
              ],
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final img =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (img != null) {
                        setState(() {
                          image = img;
                        });
                      }
                    },
                    label: const Text('Choose Image'),
                    icon: const Icon(Icons.image),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final img =
                          await picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        image = img;
                      });
                    },
                    label: const Text('Take Photo'),
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ],
              ).paddingTop(10),
              if (image != null)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: Image.file(File(image!.path))),
                      Flexible(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              label: const Text('Remove Image'),
                              icon: const Icon(Icons.close),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                setState(() {
                                  _bloc.image = image;
                                  EasyLoading.show(
                                      dismissOnTap: true);
                                  Future
                                          .delayed(
                                              const Duration(
                                                  milliseconds: 2000), () {
                                    _bloc.updateAvatar();
                                  })
                                      .then((value) => EasyLoading.dismiss())
                                      .then((value) => toastEditComplete(""));
                                });
                              },
                              label: const Text('Save Image'),
                              icon: const Icon(Icons.save),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
