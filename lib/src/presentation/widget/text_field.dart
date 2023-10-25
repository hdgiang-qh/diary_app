import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'common_widget.dart';

class CustomTextField extends StatelessWidget {
  final TextFieldType textFieldType;
  final String? hintText;
  final TextEditingController? controller;
  final String? errorText;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool isPass;
  final Function(String)? onCompleted;

  const CustomTextField(
      {Key? key,
      required this.textFieldType,
      this.hintText,
      this.controller,
      this.errorText,
      this.validator,
      this.onChanged,
      this.isPass = false,
      this.onCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      textFieldType: textFieldType,
      decoration: inputDecoration(
        context,
        hintText: hintText,
        errorText: errorText,
      ),
      validator: validator,
      onChanged: onChanged,
      isPassword: isPass,
      onFieldSubmitted: onCompleted,
      inputFormatters: textFieldType == TextFieldType.NUMBER
          ? [
              CurrencyTextInputFormatter(
                decimalDigits: 0,
                name: "",
                locale: "vi",
              ),
            ]
          : null,
    );
  }
}
