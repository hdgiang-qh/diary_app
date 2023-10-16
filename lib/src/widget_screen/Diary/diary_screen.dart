import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Diary"),
          actions: [
            IconButton(onPressed: () {
              if (kDebugMode) {
                print("hello");
              }
            }, icon: const Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.yellow
                ),
                height: 200,
                width: double.infinity,
                child: const Text("new"),
              ),

            ],
          ),
        ).paddingSymmetric(horizontal: 5));
  }
}
