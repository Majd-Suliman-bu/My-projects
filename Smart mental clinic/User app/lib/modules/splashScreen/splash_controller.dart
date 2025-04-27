import 'package:get/get.dart';

class SplashController extends GetxController {
  void startTimer() {
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the login screen after 3 seconds

      Get.toNamed(
          '/Login'); // Use the appropriate route name for your login screen
    });
  }
}
