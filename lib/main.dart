
import 'package:diary/src/core/service/provider_token.dart';
import 'package:diary/src/presentation/Auth/ChangePass/change_pass.dart';
import 'package:diary/src/presentation/Auth/Welcome/LogIn_screen.dart';
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
        '/login' : (context) => LoginPage(),
       // '/changePass' : (context) => const ChangePass()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

