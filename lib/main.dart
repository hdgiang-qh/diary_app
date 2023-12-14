

import 'package:diary/splash_screen.dart';
import 'package:diary/src/core/service/provider_token.dart';
import 'package:diary/src/dash_board.dart';
import 'package:diary/src/presentation/Auth/Welcome/LogIn_screen.dart';
import 'package:diary/src/presentation/Diary/diary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        '/login' : (context) => const LoginPage(),
        '/dashboard' : (context) => const DashBoard(),
        '/dashboard/diaryuser' : (context) => const DiaryScreen()
      },
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home:  const SplashScreen(),
      //color: Colors.cyan,
    );
  }
}



