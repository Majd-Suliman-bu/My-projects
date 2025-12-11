import 'package:flutter/material.dart';
import '../config/constant.dart';

class TextInput extends StatelessWidget {
  final String hintText;
  final double height, width;
  final int? maxlength;
  final TextInputType? inputType;
  final Function(String) onChange;
  final Color? color;
  String? lableText;

  TextInput(
      {required this.width,
      required this.height,
      required this.hintText,
      this.inputType,
      this.maxlength,
      this.color,
      this.lableText,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: width,
      height: height,
      decoration: BoxDecoration(
          // color: white,
          ),
      child: Center(
        child: TextField(
          maxLength: maxlength,
          onChanged: onChange,
          cursorColor: silver,
          keyboardType: inputType ?? TextInputType.text,
          style: const TextStyle(
            color: textcolor,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: white,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: silver,
              fontSize: 20,
            ),
            labelText: lableText,
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
