import 'package:flutter/material.dart';

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[500],
      width: MediaQuery.of(context).size.width,
      height: 5.0,
    );
  }
}