import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';

import '../theme/themeController.dart';
import 'forgorPassword_service.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final storage = FlutterSecureStorage();
  ForgotPasswordService forgotPasswordService = ForgotPasswordService();
  final RxBool isResetLoading =
      false.obs; // Add loading state for reset password
  final RxBool isVerificationLoading =
      false.obs; // Add loading state for send verification code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                height: MediaQuery.of(context).size.height *
                    0.2, // Adjust the size as needed
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                  child: Image.asset("assets/images/logo22.png"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Text('Enter the email linked to your account',
                  style: GoogleFonts.merriweather(
                      textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              _buildEmailField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Obx(() {
                if (isResetLoading.value) {
                  return CircularProgressIndicator(); // Show loading indicator
                } else {
                  return ElevatedButton(
                    onPressed: () async {
                      isResetLoading.value = true; // Set loading state to true
                      String email = emailController.text;
                      if (_validateEmail(email)) {
                        int checkResult =
                            await forgotPasswordService.checkEmail(email);
                        if (checkResult == 0) {
                          // Email is verified, proceed to OTP page
                          bool otpSent =
                              await forgotPasswordService.ResendOTP(email);
                          if (otpSent) {
                            customSnackBar(
                              "Check your email",
                              "We sent a code to your email",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            await storage.write(key: 'userEmail', value: email);
                            await storage.write(
                                key: 'resetpassword', value: "1");
                            Get.offNamed('/OTP');
                          } else {
                            customSnackBar(
                              "Error",
                              ForgotPasswordService.error ??
                                  "Failed to resend OTP",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else if (checkResult == 2) {
                          // Email not found
                          customSnackBar(
                            "Error",
                            "Email not found",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else {
                          // Unknown error
                          customSnackBar(
                            "Error",
                            "Verify your email first",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } else {
                        // Email format is incorrect
                        customSnackBar(
                          "Error",
                          "Please enter a valid email address",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      isResetLoading.value =
                          false; // Set loading state to false
                    },
                    child: Text(
                      'Reset password',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 21, 56, 85),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Obx(() {
                if (isVerificationLoading.value) {
                  return CircularProgressIndicator(); // Show loading indicator
                } else {
                  return ElevatedButton(
                    onPressed: () async {
                      isVerificationLoading.value =
                          true; // Set loading state to true
                      String email = emailController.text;
                      if (_validateEmail(email)) {
                        int checkResult =
                            await forgotPasswordService.checkEmail(email);
                        if (checkResult == 1) {
                          // Email is not verified, resend OTP
                          bool otpSent =
                              await forgotPasswordService.ResendOTP(email);
                          if (otpSent) {
                            customSnackBar(
                              "Success",
                              "Verification code sent to $email",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            await storage.write(key: 'userEmail', value: email);
                            await storage.write(
                                key: 'resetpassword', value: "0");
                            Get.offNamed('/OTP');
                          } else {
                            customSnackBar(
                              "Error",
                              ForgotPasswordService.error ??
                                  "Failed to resend OTP",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else if (checkResult == 0) {
                          // Email already verified
                          customSnackBar(
                            "Error",
                            "Email already verified",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else if (checkResult == 2) {
                          // Email not registered
                          customSnackBar(
                            "Error",
                            "Please register first",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } else {
                        customSnackBar(
                          "Error",
                          "Please enter a valid email address",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      isVerificationLoading.value =
                          false; // Set loading state to false
                    },
                    child: Text(
                      'Send verification code',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 21, 56, 85),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
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
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 21, 56, 85)),
          hintText: 'Email',
          hintStyle: TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
          border: GradientOutlineInputBorder(
              gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
              width: 2,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(email);
  }
}
