
import 'package:flutter/material.dart';

class MessBotScreen extends StatefulWidget {
  const MessBotScreen({super.key});

  @override
  State<MessBotScreen> createState() => _MessBotScreenState();
}

class _MessBotScreenState extends State<MessBotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot App'),
      automaticallyImplyLeading: false,),
      body: const Column(
      ),
    );
  }


}
