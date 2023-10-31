import 'package:diary/src/test2.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../Auth/provider_token.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController textController;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: '');
  }



  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Diary For You",
        ),
        actions: [
          GestureDetector(
            child: const CircleAvatar(
              backgroundColor: primaryColor,
              child: Text('G'),
            ).paddingRight(10),
            onTap: () {
              if (kDebugMode) {
                print('hello');
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: CupertinoSearchTextField(
                controller: textController,
                placeholder: 'Search',
              ),
            ),
            Center(
              child: SizedBox(width: 400, child: Text("Token : $token")),
            )
          ],
        ),
      ),
    );
  }
}
