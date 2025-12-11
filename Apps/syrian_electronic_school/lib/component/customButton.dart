import 'package:flutter/material.dart';

import '../config/constant.dart';

class Button extends StatelessWidget {
  final double hight, width;
  final double fontsize;
  final Color buttonColor, nameColor;
  final String? buttonName;
  final Function() ontap;
  bool? isbold;

  Button({required this.hight,
    required this.width,
    required this.buttonColor,
    required this.buttonName,
    required this.ontap,
    required this.fontsize,
    this.isbold=false,
    required this.nameColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:ontap,
      child: Container(
        height: hight,
        width: width,


        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Center(
          child: Text(
            buttonName!,
            style: TextStyle(
              color: nameColor,
              fontSize: fontsize,
              fontWeight: isbold!?FontWeight.bold:FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
