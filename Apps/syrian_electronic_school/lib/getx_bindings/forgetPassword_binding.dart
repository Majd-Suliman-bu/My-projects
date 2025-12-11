import 'package:get/get.dart';

import '../modules/forgetPassword/forgetPassword_controller.dart';

class ForgetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ForgetPasswordController>(ForgetPasswordController());
  }
}
