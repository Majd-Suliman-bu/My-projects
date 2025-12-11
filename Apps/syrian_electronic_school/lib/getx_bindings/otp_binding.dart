import 'package:get/get.dart';
import '../modules/OTP/otp_controller.dart';

class OtpBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<OtpController> (OtpController());
  }

}