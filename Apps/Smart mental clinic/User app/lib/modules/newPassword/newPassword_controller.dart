import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  var password = ''.obs;
  var formSubmitted = false.obs;
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }
}
