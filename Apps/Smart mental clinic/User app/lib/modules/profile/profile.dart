import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_medical_clinic/modules/profile/custom_refresh_indicator.dart';
import 'profile_controller.dart';
import 'profile_service.dart'; // Ensure this import is correct

class Profile extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();
  ProfileController controller = Get.find();
  FlutterSecureStorage storage =
      FlutterSecureStorage(); // Secure storage instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (controller.isLoading.isTrue) {
        return Center(child: CircularProgressIndicator());
      } else {
        return customRefreshIndicator(
          () async {
            controller.onInit();
          },
          ListView(children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  // Add the asset picture here

                  Image.asset(
                    "assets/images/profilepic.png", // Replace with your asset path
                    height: MediaQuery.of(context).size.height *
                        0.2, // Adjust size as needed
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Text(controller.userprofile.value?.data.username ?? '',
                      style: GoogleFonts.merriweather(
                          textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.065,
                        fontWeight: FontWeight.bold,
                      ))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Obx(() => Text(
                        "${'Balance'.tr}: ${controller.userprofile.value?.data.wallet.balance}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.045, // Dynamic size
                        ),
                      )),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Text(
                    controller.userprofile.value?.data.email ??
                        '', // Assuming static for demonstration

                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.04, // Dynamic size
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/Reservations');
                    },
                    child: Text(
                      "My reservations".tr,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width *
                            0.04, // Dynamic size
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  ElevatedButton(
                    onPressed: () => _showRedeemDialog(context),
                    style: ElevatedButton.styleFrom(),
                    child: Text(
                      "Redeem".tr,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width *
                            0.04, // Dynamic size
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      }
    }));
  }

  void _showRedeemDialog(BuildContext context) {
    TextEditingController _codeController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Obx(() => AlertDialog(
              title: Text("Enter card code".tr),
              content: controller
                      .isLoading.value // Corrected to use controller.isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(height: 20),
                          Text("Verifying...".tr,
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    )
                  : TextField(
                      controller: _codeController,
                      maxLength: 8,
                      decoration: InputDecoration(hintText: "8-chars code".tr),
                    ),
              actions: <Widget>[
                if (!controller.isLoading.value) // Also corrected here
                  TextButton(
                    child: Text("Close".tr),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                if (!controller.isLoading.value) // Corrected condition
                  TextButton(
                    child: Text("OK".tr),
                    onPressed: () async {
                      await controller.verifyCode(_codeController.text);

                      Navigator.pop(context);
                    },
                  ),
              ],
            ));
      },
    );
  }
}
