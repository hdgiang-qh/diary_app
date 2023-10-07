import 'package:flutter/material.dart';

class MessBotScreen extends StatefulWidget {
  const MessBotScreen({super.key});

  @override
  State<MessBotScreen> createState() => _MessBotScreenState();
}

class _MessBotScreenState extends State<MessBotScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("MessBot", style: TextStyle(fontSize: 16),),
      ),
    );
  }
}
