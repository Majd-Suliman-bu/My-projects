import 'package:get/get.dart';

import '../modules/OTP/otp_controller.dart';

class OTPBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<OTPController>(OTPController());
  }
}
