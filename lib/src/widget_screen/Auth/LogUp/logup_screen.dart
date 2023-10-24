import 'package:flutter/material.dart';

class LogUpScreen extends StatefulWidget {
  const LogUpScreen({super.key});

  @override
  State<LogUpScreen> createState() => _LogUpScreenState();
}

class _LogUpScreenState extends State<LogUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/register.png'),
            fit: BoxFit.cover
          )
        ),
        child: const SafeArea(
          child: Text("hello"),
        ),
      ),
    );
  }
}
