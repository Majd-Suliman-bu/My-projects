import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var email = ''.obs;
  var password = ''.obs;
  var formSubmitted = false.obs; // Tracks if the form has been submitted
  late TextEditingController emailController;
  late TextEditingController passwordController;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController(text: email.value);
    passwordController = TextEditingController(text: password.value);

    // Bind text changes to Rx variables
    emailController.addListener(() {
      email.value = emailController.text;
    });
    passwordController.addListener(() {
      password.value =
          passwordController.text; // Update password observable on change
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
