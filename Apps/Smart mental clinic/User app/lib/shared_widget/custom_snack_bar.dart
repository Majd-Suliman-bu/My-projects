import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

bool isThereIsSnackBar = false;
bool isEndUserSession = false;

SnackbarController customSnackBar(
  String title,
  String message, {
  backgroundColor = Colors.green,
  colorText = Colors.white,
  snackPosition = SnackPosition.TOP,
  double borderRadius = 20,
  EdgeInsets margin = const EdgeInsets.all(10),
  snackStyle = SnackStyle.FLOATING,
}) {
  title = endUserSession(title);
  print('in the snackbar: $title');
  return Get.snackbar(
    title.tr,
    message,
    backgroundColor: backgroundColor,
    messageText: Text(message, style: TextStyle(color: colorText)),
    borderRadius: borderRadius,
    margin: margin,
    snackStyle: snackStyle,
    snackPosition: snackPosition,
  );
}

String endUserSession(String title) {
  if (!isEndUserSession) {
    if (title == 'jwt expired.' ||
        title == 'User not found.' ||
        title == 'Not allowed.' ||
        title == 'jwt expired' ||
        title == 'User not found' ||
        title == 'Not allowed' ||
        title == 'No Token Provided.' ||
        title == 'No Token Provided' ||
        title == 'There is another session open , please login again') {
//logout.
      logout();
      if (title != 'There is another session open , please login again') {
        title =
            "Your session has expired. Please log in again to continue using the app."
                .tr;
      }
    }
  }
  return title;
}

logout() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  await storage.delete(key: "accessToken");
  // Navigate to the landing page
  Get.offAllNamed("/Landing");
}
