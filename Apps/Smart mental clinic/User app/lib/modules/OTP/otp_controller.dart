import 'package:get/get.dart';
import 'dart:async';

class OTPController extends GetxController {
  var otpError = false.obs;
  var resendEnabled = false.obs;
  var countdown = 10.obs; // Countdown time in seconds

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    resendEnabled.value = false;
    countdown.value = 10; // Reset to 10 seconds
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Change to 1 second
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        resendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  void setOtpError(bool isError) {
    otpError.value = isError;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
