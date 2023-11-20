import 'package:diary/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ItemLoadFail extends StatelessWidget {
  final String msg;
  final Function onRefresh;
  const ItemLoadFail({Key? key, required this.msg, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(msg, style: StyleApp.textStyle400(),),
          5.height,
          AppButton(
            onTap: onRefresh,
            text: 'Tải lại',
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
