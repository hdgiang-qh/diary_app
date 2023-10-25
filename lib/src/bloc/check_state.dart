
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../styles/text_style.dart';

import '../presentation/widget/dia_log_item.dart';
import 'bloc_status.dart';
import 'cubit_state.dart';


class CheckState {
  static check(BuildContext context, CubitState state,
      {String? msg, bool isShowMsg = true, Function()? success}) {
    if (state.status == BlocStatus.loading) {
      DialogItem.showLoading(context: context);
    }
    if (state.status == BlocStatus.sucsess) {
      DialogItem.hideLoading(context: context);
      isShowMsg
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  msg ?? state.msg,
                  style: StyleApp.textStyle400(color: Colors.white),
                ),
              ),
            )
          : null;
      if (success != null) {
        success();
      }
    }
    if (state.status == BlocStatus.loadfail) {
      DialogItem.hideLoading(context: context);
      DialogItem.showMsg(
        context: context,
        title: "Lỗi",
        msg: state.msg,
      );
    }
  }
}
