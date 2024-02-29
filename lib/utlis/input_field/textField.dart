import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.onValidator,
    required this.hintText,
    required this.prefixIcon,
    this.keyBoardType = TextInputType.emailAddress,
    this.obscureText = false,
    this.enable = true,
    this.autoFocus = false,
    this.suffixIcon,
    this.maxline = 1,
  });
  final TextEditingController controller;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final String hintText;
  final bool obscureText, enable, autoFocus;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final int? maxline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: TextFormField(
        maxLines: maxline,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyBoardType,
        validator: onValidator,
        enabled: enable,
        autofocus: autoFocus,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(17),
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
