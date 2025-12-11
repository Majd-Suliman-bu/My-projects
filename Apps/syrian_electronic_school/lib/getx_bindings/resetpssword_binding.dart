import 'package:get/get.dart';
import '../modules/resetPassword/resetPassword_controller.dart';

class ResetPasswordBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<ResetPasswordController> (ResetPasswordController());
  }

}