import 'package:get/get.dart';

import 'otp_service.dart';

class OtpController extends GetxController {
  var email ="";
  var checkStatus;
  var msg;
  var error;
  var otp;
  late OtpService service;

  @override
  void onInit() {
    checkStatus = false;
    service = OtpService();
    super.onInit();
  }
  Future<void> forgetPasswordVerifyClick(String otp) async {
    print("controller ");
    checkStatus = await service.sendForgetPasswordOtpVerificationRequest(otp);
    if (checkStatus) {
      msg = service.msg;
    } else {
      error = service.error;
    }

  }
  Future<void> registerVerifyClick(String otp) async {

    checkStatus = await service.sendRegisterOtpVerificationRequest(otp);
    if (checkStatus) {
      msg = service.msg;
    } else {
      error = service.error;
    }

  }
}

