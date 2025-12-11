import 'package:get/get.dart';
import '../../modules/resetPassword/resetPassword_service.dart';

class ResetPasswordController extends GetxController {
  var password;
  var c_password;

  var resetStatus;
  var msg;
  var error;
  late ResetPasswordService service;

  @override
  void onInit() {

    resetStatus = false;
    service = ResetPasswordService();
    super.onInit();
  }


  Future<void> resetClick(String email , String otp,String password) async {
    resetStatus = await service.sendResetPasswordRequest(email,otp,password);
    if (resetStatus) {
      msg = service.msg;
    } else {
      error = service.error;
    }
  }
}
