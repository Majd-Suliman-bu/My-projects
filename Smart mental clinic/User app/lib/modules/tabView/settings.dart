import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/tabView/terms_of_use.dart';
import '../theme/themeController.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final ThemeController themeController = Get.find();
    final RxString currentLocale = ''.obs; // Track current locale

    // Initialize current locale
    currentLocale.value = Get.locale.toString();

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          themeSwitchButton(themeController),
          // Language Switch Button
          languageSwitchButton(currentLocale),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          GestureDetector(
            onTap: () {
              termOfUseBottomSheet(context);
            },
            child: Text(
              "Terms of Use".tr,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline,
                fontSize: 19,
                color: Colors.white60,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),

          ElevatedButton(
            onPressed: () async {
              await storage.delete(key: "accessToken");
              // Navigate to the landing page
              Get.offAllNamed("/Landing");
            },
            style: ElevatedButton.styleFrom(),
            child: Text(
              "Logout".tr,
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width * 0.04, // Dynamic size
              ),
            ),
          ),
        ],
      ),
    );
  }

  Obx themeSwitchButton(ThemeController themeController) {
    return Obx(
      () => SwitchListTile(
        title: Text('Dark Mode'),
        value: themeController.themeData.value.brightness == Brightness.dark,
        onChanged: (bool value) {
          themeController.switchTheme(value);
        },
      ),
    );
  }

  Obx languageSwitchButton(RxString currentLocale) {
    return Obx(
      () => SwitchListTile(
        title: Text(currentLocale.value == 'en_US' ? 'English' : 'عربي'),
        value: currentLocale.value == 'ar_SY',
        onChanged: (bool value) {
          // Toggle between languages
          if (value) {
            Get.updateLocale(const Locale('ar', 'SY'));
            currentLocale.value = 'ar_SY';
          } else {
            Get.updateLocale(const Locale('en', 'US'));
            currentLocale.value = 'en_US';
          }
        },
      ),
    );
  }
}
