import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Initialize theme data with the dark theme
  Rx<ThemeData> themeData = _darkTheme().obs;

  // Method to create the initial light theme
  static ThemeData _initialLightTheme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.grey,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF00ADB5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            textStyle: TextStyle(
                color: Colors
                    .red) // Set global background color to red for ElevatedButtons
            ),
      ),
    );
  }

  void switchTheme(bool isDarkMode) {
    themeData.value = isDarkMode ? _darkTheme() : _lightTheme();
  }

  static ThemeData _lightTheme() {
    // Reuse the initial light theme method
    return _initialLightTheme();
  }

  static ThemeData _darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFF393E46),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF00ADB5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            textStyle: TextStyle(
                color: Colors
                    .red) // Set global background color to red for ElevatedButtons
            ),
      ),
    );
  }
}
