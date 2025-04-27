import 'package:get/get.dart';

import '../modules/newPassword/newPassword_controller.dart';

class NewPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NewPasswordController>(NewPasswordController());
  }
}
