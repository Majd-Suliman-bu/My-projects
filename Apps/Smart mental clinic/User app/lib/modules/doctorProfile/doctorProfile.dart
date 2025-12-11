import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/server_config.dart';
import 'doctorProfile_controller.dart';

class DoctorProfile extends StatelessWidget {
  DoctorProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Color.fromARGB(255, 89, 155, 222);
    // Define dynamic font sizes based on screen height

    final double nameFontSize = MediaQuery.of(context).size.height * 0.05;
    final double cityFontSize = MediaQuery.of(context).size.height * 0.035;
    final double degreeFontSize = MediaQuery.of(context).size.height * 0.03;
    final double sessionCostFontSize =
        MediaQuery.of(context).size.height * 0.025;
    final double buttonFontSize = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // controller.doctorProfile.value!.data.name,
          'Dr profile'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: themeColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                        controller.doctorProfile.value!.data.photo),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    controller.doctorProfile.value!.data.name,
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      controller.doctorProfile.value!.data.address,
                      style: TextStyle(
                          fontSize: cityFontSize, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        controller.doctorProfile.value!.data.studyInfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: degreeFontSize, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    "${'Session Cost'.tr}: ${controller.doctorProfile.value!.data.sessionPrice}",
                    style: TextStyle(
                      fontSize: sessionCostFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ElevatedButton(
                    onPressed: () => _showConfirmationDialog(context),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text("Book Session".tr,
                        style: TextStyle(fontSize: buttonFontSize)),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  void _showConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?".tr),
          content: Text(
              "When approved from the doctor, you will have to pay the session cost."
                  .tr),
          actions: [
            TextButton(
              child: Text("No".tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes".tr),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog
                // Show loading dialog
                controller.isLoading.value = true;

                // Call the RequestAppointment method from the controller
                await controller.RequestAppointment(
                    controller.doctorProfile.value!.data.clinicId);
                controller.isLoading.value = false;
              },
            ),
          ],
        );
      },
    );
  }
}
