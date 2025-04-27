import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:smart_medical_clinic/modules/theme/themeController.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';

import 'otp_controller.dart';
import 'otp_service.dart';

class OTP extends StatelessWidget {
  OTPController otpController = Get.find();
  OTPService otpService = OTPService();
  final OtpFieldController otpFieldController = OtpFieldController();
  final storage = FlutterSecureStorage();
  final RxBool isLoading = false.obs; // Add loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset("assets/images/logo22.png"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.13),
              Text('Enter your six digits code',
                  style: GoogleFonts.merriweather(
                      textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Obx(() {
                final otpError = otpController.otpError.value;
                return OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 45,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 10,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.black),
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: otpError ? Colors.red : Colors.black26,
                    focusBorderColor: otpError ? Colors.red : Colors.blue,
                    errorBorderColor: Colors.red,
                  ),
                  controller: otpFieldController,
                  onChanged: (pin) {
                    print("Changed: " + pin);
                    otpController
                        .setOtpError(false); // Reset error state on change
                  },
                  onCompleted: (pin) async {
                    String? value = await storage.read(key: 'resetpassword');

                    if (value == "1") {
                      bool isValidToken = await otpService.VerifyToken(pin);
                      if (isValidToken) {
                        await storage.write(key: 'token', value: pin);
                        customSnackBar(
                          "Success",
                          "Enter new password",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          borderRadius: 20,
                          margin: EdgeInsets.all(10),
                          snackStyle: SnackStyle.FLOATING,
                        );
                        Get.offNamed(
                            '/NewPassword'); // Navigate to login page on success
                      } else {
                        otpController
                            .setOtpError(true); // Set error state on failure
                        customSnackBar(
                          "Wrong code",
                          OTPService.error ?? "The code you entered is wrong",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          borderRadius: 20,
                          margin: EdgeInsets.all(10),
                          snackStyle: SnackStyle.FLOATING,
                        );
                      }
                    } else {
                      bool isValid = await otpService.verifyOTP(pin);
                      if (isValid) {
                        customSnackBar(
                          "Success",
                          "You can now login",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          borderRadius: 20,
                          margin: EdgeInsets.all(10),
                          snackStyle: SnackStyle.FLOATING,
                        );
                        Get.offNamed(
                            '/Login'); // Navigate to login page on success
                      } else {
                        otpController
                            .setOtpError(true); // Set error state on failure
                        customSnackBar(
                          "Wrong code",
                          OTPService.error ?? "The code you entered is wrong",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          borderRadius: 20,
                          margin: EdgeInsets.all(10),
                          snackStyle: SnackStyle.FLOATING,
                        );
                      }
                    }
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Obx(() {
                if (isLoading.value) {
                  return CircularProgressIndicator(); // Show loading indicator
                } else {
                  return ElevatedButton(
                    onPressed: otpController.resendEnabled.value
                        ? () async {
                            isLoading.value = true; // Set loading state to true
                            String? email =
                                await storage.read(key: 'userEmail');
                            bool result = await otpService.ResendOTP(email!);
                            isLoading.value =
                                false; // Set loading state to false
                            if (result) {
                              otpController.startTimer(); // Restart timer
                              customSnackBar(
                                "Code has been resent",
                                "Check your email",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                borderRadius: 20,
                                margin: EdgeInsets.all(10),
                                snackStyle: SnackStyle.FLOATING,
                              );
                            } else {
                              customSnackBar(
                                "User not found",
                                OTPService.error ?? "Failed to resend OTP",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                borderRadius: 20,
                                margin: EdgeInsets.all(10),
                                snackStyle: SnackStyle.FLOATING,
                              );
                            }
                          }
                        : null,
                    child: Text(
                      'Resend code',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: otpController.resendEnabled.value
                          ? Color.fromARGB(255, 21, 56, 85)
                          : Colors.grey,
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Obx(() => Text(
                    "${otpController.countdown.value} seconds remaining",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
