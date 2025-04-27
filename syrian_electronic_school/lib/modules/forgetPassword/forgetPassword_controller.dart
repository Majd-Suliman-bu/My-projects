import 'package:get/get.dart';
import '../../modules/forgetPassword/forgetPassword_service.dart';

class ForgetPasswordController extends GetxController {
  var email ="";
  var requestStatus;
  var msg;
  var error;
  late ForgetPasswordService service;

  @override
  void onInit() {

    requestStatus = false;
    service = ForgetPasswordService();
    super.onInit();
  }


  Future<void> resetClick(String email) async {
    requestStatus = await service.sendResetPasswordRequest(email);
    if (requestStatus) {
      msg = service.msg;
    } else {
      error = service.error;
    }
  }
}
