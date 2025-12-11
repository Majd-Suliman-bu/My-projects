import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isThereIsSnackBar = false;
bool isEndUserSession = false;

ScaffoldFeatureController? customSnackBarmm(String title, BuildContext context,
    {bool isFloating = false}) {
  title = endUserSession(context, title);
  // MessageLogger.logMessage(title);
  if (!isThereIsSnackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: isFloating ? SnackBarBehavior.floating : null,
        backgroundColor: Color(0xff14181b),
        onVisible: () {
          isThereIsSnackBar = true;
          makeIsThereIsSnackBarVarFalseAfterTheSnackBarClosed();
        },
        duration: const Duration(seconds: 2),
        content: Text(
          title.tr,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
  return null;
}

makeIsThereIsSnackBarVarFalseAfterTheSnackBarClosed() {
  return Future.delayed(const Duration(seconds: 2), () {
    isThereIsSnackBar = false;
  });
}

makeIsisEndUserSessionVarFalseAfterTheSnackBarClosed() {
  return Future.delayed(const Duration(seconds: 2), () {
    isEndUserSession = false;
  });
}

String endUserSession(BuildContext context, String title) {
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
      // logOut();
      // logOutClearBloc(context);
      if (title != 'There is another session open , please login again') {
        title =
            "Your session has expired. Please log in again to continue using the app."
                .tr;
      }
      isEndUserSession = true;
      makeIsisEndUserSessionVarFalseAfterTheSnackBarClosed();
    }
  }
  return title;
}
