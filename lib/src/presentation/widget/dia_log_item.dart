import 'package:flutter/material.dart';

import '../../../styles/text_style.dart';



class DialogItem {
  static showMsg({
    required BuildContext context,
    required String title,
    String cancel = "Đóng",
    String confirm = "Đồng ý",
    required String msg,
    Function()? onConfirm,
    Function()? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: StyleApp.textStyle700(),
          textAlign: TextAlign.center,
        ),
        content: Text(
          msg,
          style: StyleApp.textStyle400(),
          textAlign: TextAlign.left,
        ),
        actionsPadding: const EdgeInsets.only(bottom: 15),
        actions: [
          onConfirm == null
              ? const SizedBox()
              : TextButton(
                  onPressed: onConfirm,
                  child: Text(
                    confirm,
                    style: StyleApp.textStyle400(),
                  ),
                ),
          TextButton(
            onPressed: onCancel ??
                () {
                  Navigator.pop(context);
                },
            child: Text(
              cancel,
              style: StyleApp.textStyle400(),
            ),
          )
        ],
      ),
    );
  }

  static showLoading({
    required BuildContext context,
    String title = "Đang tải",
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.75),
        content: Container(
          height: 80,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
           // color: Colors.black.withOpacity(0.75),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "$title...",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: StyleApp.textStyle400(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.of(context).pop(DialogItem);
  }
}
