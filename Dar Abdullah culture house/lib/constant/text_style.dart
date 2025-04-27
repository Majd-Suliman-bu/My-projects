import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worker_app/constant/fonts.dart';
import 'package:worker_app/constant/theme.dart';

TextStyle generalTextStyle(double? size) {
  return TextStyle(
      fontFamily: jostFontFamily,
      color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
      fontSize: size);
}
