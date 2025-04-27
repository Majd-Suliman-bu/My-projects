import 'package:get/get.dart';

import '../modules/forgotPassword/forgotPassword_controller.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ForgotPasswordController>(ForgotPasswordController());
  }
}
