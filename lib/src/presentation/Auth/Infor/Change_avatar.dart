import 'dart:io';

import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.purple8a,
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
                ColorAppStyle.purple6f,
                ColorAppStyle.purple8a,
                ColorAppStyle.blue75
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
                      final ImagePicker _picker = ImagePicker();
                      final img =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        image = img;
                      });
                    },
                    label: const Text('Choose Image'),
                    icon: const Icon(Icons.image),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final img =
                          await _picker.pickImage(source: ImageSource.camera);
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
                      Expanded(
                          flex: 2,child: Image.file(File(image!.path))),
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
                              onPressed: () {
                                setState(() {
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