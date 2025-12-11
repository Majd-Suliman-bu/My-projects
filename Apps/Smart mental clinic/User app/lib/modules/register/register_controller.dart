import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var selectedJob = Rx<String?>(null);
  var selectedRelationshipStatus = Rx<String?>(null);
  var selectedGender = Rx<String?>(null);
  var selectedDateOfBirth = Rx<DateTime?>(null);
  var password = ''.obs;
  var formSubmitted = false.obs; // Tracks if the form has been submitted
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  var email = ''.obs;
  var noc = ''.obs;
  var how = ''.obs;
  var pow = ''.obs;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController nocController;
  late TextEditingController howController;
  late TextEditingController powController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController(text: email.value);
    passwordController = TextEditingController(text: password.value);
    confirmPasswordController = TextEditingController();
    nocController = TextEditingController(text: noc.value);
    howController = TextEditingController(text: how.value);
    powController = TextEditingController(text: pow.value);

    // Bind text changes to Rx variables
    emailController.addListener(() {
      email.value = emailController.text;
    });
    passwordController.addListener(() {
      password.value =
          passwordController.text; // Update password observable on change
    });
    nocController.addListener(() {
      noc.value = nocController.text;
    });
    howController.addListener(() {
      how.value = howController.text;
    });
    powController.addListener(() {
      pow.value = powController.text;
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nocController.dispose();
    howController.dispose();
    powController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
}
