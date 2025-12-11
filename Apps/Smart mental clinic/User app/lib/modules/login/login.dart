import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';

import '../../models/user.dart';
import '../theme/themeController.dart';
import 'login_controller.dart';
import 'login_service.dart';

final _formKey = GlobalKey<FormState>(); // Add a form key

class Login extends StatelessWidget {
  LoginController controller = Get.find();
  final ThemeController themeController = Get.find();

  //color: Color.fromARGB(255, 21, 56, 85)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, //
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.27, // Adjust the size as needed
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                    child: Image.asset(
                      "assets/images/logo22.png",
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text('Welcome',
                    style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.065,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
                SizedBox(height: 5),
                Text('Login to your account',
                    style: GoogleFonts.merriweather(
                        textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                _buildUsernameField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                _buildPasswordField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Obx(() {
                  if (controller.isLoading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.formSubmitted.value = true;
                          _handleLogin(context);
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 21, 56, 85),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.7,
                            MediaQuery.of(context).size.height * 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  }
                }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                GestureDetector(
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 21, 56, 85)),
                  ),
                  onTap: () {
                    Get.offNamed('Register');
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 163, 192, 222), // Light grey color
            Color.fromARGB(255, 127, 176, 226), // Dark grey color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          }
          return null;
        },
        controller: controller.emailController,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red),
          prefixIcon:
              const Icon(Icons.person, color: Color.fromARGB(255, 21, 56, 85)),
          hintText: 'Email',
          hintStyle: const TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
          border: GradientOutlineInputBorder(
              gradient:
                  const LinearGradient(colors: [Colors.white, Colors.blue]),
              width: 2,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 163, 192, 222), // Light grey color
                Color.fromARGB(255, 127, 176, 226)!, // Dark grey color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password'.tr;
              }
              return null;
            },
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.lock, color: Color.fromARGB(255, 21, 56, 85)),
              hintText: 'Password',
              hintStyle: TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
              border: GradientOutlineInputBorder(
                  gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
                  width: 2,
                  borderRadius: BorderRadius.circular(10)),
              errorStyle: const TextStyle(color: Colors.red),
              suffixIcon: IconButton(
                icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color.fromARGB(255, 21, 56, 85)),
                onPressed: () {
                  controller.togglePasswordVisibility();
                },
              ),
            ),
          ),
        ));
  }

  void _handleLogin(BuildContext context) async {
    controller.isLoading.value = true; // Show loading indicator
    controller.formSubmitted.value = true;

    // Create a User object from the form data

    User newUser = User(
      email: controller.email.value,
      password: controller.password.value,
    );

    // Call the register service
    bool isLoggedin = await LoginService().Login(newUser);
    controller.isLoading.value = false; // Hide loading indicator
    if (isLoggedin) {
      Get.offAllNamed("/TabView");
    } else {
      customSnackBar("Error",
          "Login failed: ${LoginService.error}", // Access static error variable
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
