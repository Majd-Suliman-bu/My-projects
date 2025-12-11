import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/server_config.dart';
import '../native_service/secure_storage.dart';

class RedeemCodeController extends GetxController {
  final TextEditingController codeController = TextEditingController();
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs; // Loading indicator state
  final Securestorage storage = Securestorage();
  late String token;

  Future<void> getToken() async {
    token = await storage.read("Access Token") ?? '';
    print(token);
  }

  Future<void> redeemCode(BuildContext context) async {
    isLoading.value = true; // Start loading
    await getToken();
    var response = await http.post(
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.sendCourseCode),
      body: {'code': codeController.text},
      headers: {
        "Accept": "application/json",
        "Authorization": token,
      },
    );

    isLoading.value = false; // Stop loading
    if (response.statusCode == 200) {
      errorMessage.value = '';

      Get.snackbar('Success', 'Course added successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      Navigator.pop(context); // Use Navigator.pop with context
    } else {
      var responseBody = json.decode(response.body);
      errorMessage.value = responseBody['error'];
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}

class RedeemCodeDialog extends StatelessWidget {
  final RedeemCodeController controller = Get.put(RedeemCodeController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Redeem Code'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.codeController,
              decoration: InputDecoration(
                labelText: 'Enter Code',
                border: OutlineInputBorder(),
                errorText: controller.errorMessage.value.isEmpty
                    ? null
                    : controller.errorMessage.value,
              ),
            ),
            SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => controller.redeemCode(context),
                    child: Text('Redeem'),
                  )),
          ],
        ),
      ),
    );
  }
}
