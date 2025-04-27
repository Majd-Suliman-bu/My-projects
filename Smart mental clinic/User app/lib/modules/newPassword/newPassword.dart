import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:smart_medical_clinic/modules/newPassword/newPassword_controller.dart';
import 'package:smart_medical_clinic/modules/theme/themeController.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';

import 'newPassword_service.dart';

class NewPassword extends StatelessWidget {
  NewPasswordController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  NewPasswordService newPasswordService = NewPasswordService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  // Logo
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset("assets/images/logo22.png"),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  // Title
                  Text('Create a new password',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  _buildPasswordField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  _buildConfirmPasswordField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print('Form is valid');
                        controller.formSubmitted.value = true;

                        // Call SetNewPassword with the new password
                        bool result = await newPasswordService.SetNewPassword(
                            _passwordController.text);

                        if (result) {
                          customSnackBar(
                            "Success", // Title
                            "Password changed! Log in", // Message
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 2 -
                                    50),
                            borderRadius: 0,
                          );
                          Get.offNamed('Login');
                        } else {
                          customSnackBar(
                            "Error", // Title
                            NewPasswordService
                                .error, // Display the error message from the service
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 2 -
                                    50),
                            borderRadius: 0,
                          );
                        }
                      } else {
                        print('Form is not valid');
                        controller.formSubmitted.value = false;
                      }
                    },
                    child: Obx(() => controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Change password',
                            style: TextStyle(color: Colors.white))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 21, 56, 85),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// For the password field
  _buildPasswordField() {
    return Obx(() => _styledTextField(
          hintText: 'New Password',
          icon: Icons.lock,
          obscureText: !controller.showPassword.value,
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
          togglePasswordVisibility: () {
            controller.togglePasswordVisibility();
          },
        ));
  }

// For the confirm password field
  _buildConfirmPasswordField() {
    return Obx(() => _styledTextField(
          hintText: 'Confirm Password',
          icon: Icons.lock_outline,
          obscureText: !controller.showConfirmPassword.value,
          controller: _confirmPasswordController,
          validator: (value) {
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          togglePasswordVisibility: () {
            controller.toggleConfirmPasswordVisibility();
          },
        ));
  }

  Widget _styledTextField({
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    VoidCallback? togglePasswordVisibility, // Add this line
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 163, 192, 222),
            Color.fromARGB(255, 127, 176, 226),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 21, 56, 85)),
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
          border: GradientOutlineInputBorder(
            gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
            width: 2,
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: GradientOutlineInputBorder(
            gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
            width: 2,
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: TextStyle(color: Colors.red),
          focusedBorder: GradientOutlineInputBorder(
            gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
            width: 2,
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.transparent,
          filled: true,
          suffixIcon: togglePasswordVisibility !=
                  null // Check if the callback is not null
              ? IconButton(
                  icon: Icon(
                    // Toggle the icon based on the obscureText value
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color.fromARGB(255, 21, 56, 85),
                  ),
                  onPressed: togglePasswordVisibility, // Use the callback here
                )
              : null,
        ),
        style: TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
      ),
    );
  }
}
