import 'package:flutter/material.dart';
import '../config/constant.dart';

class TextInput extends StatefulWidget {
  final String hintText;
  final double height, width;
  final int? maxlength;
  final TextInputType? inputType;
  final Function(String) onChange;
  final Color? color;
  final String? labelText;

  TextInput({
    required this.width,
    required this.height,
    required this.hintText,
    this.inputType,
    this.maxlength,
    this.color,
    this.labelText,
    required this.onChange,
  });

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(),
      child: Center(
        child: TextField(
          maxLength: widget.maxlength,
          onChanged: (value) {
            setState(() {
              _errorText = widget.onChange(value);
            });
          },
          cursorColor: silver,
          keyboardType: widget.inputType ?? TextInputType.text,
          style: const TextStyle(
            color: textcolor,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: silver,
              fontSize: 20,
            ),
            labelText: widget.labelText,
            errorText: _errorText,
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
