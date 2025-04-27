import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/tabView/settings.dart';
import 'package:text_marquee/text_marquee.dart';
import '../chatBot/chatBot.dart';
import '../chatBot/chatBot_controller.dart';
import '../doctors/doctors.dart';
import '../doctors/doctors_controller.dart';
import '../myTherapists/myTherapists.dart';
import '../myTherapists/myTherapists_controller.dart';
import '../profile/profile.dart';
import '../profile/profile_controller.dart';
// Import your page widgets here

class TabView extends StatelessWidget {
  TabView() {
    // Initialize your controllers here
    Get.lazyPut(() => ChatBotController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => DoctorsController());
    Get.lazyPut(() => MyTherapistsController());
    // Repeat for other controllers as needed
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Smart mental clinic".tr),
          bottom: TabBar(
            isScrollable: false, // Set to false to avoid layout issues
            tabs: [
              Tab(
                child: TextMarquee(
                  'ChatBot'.tr,
                  rtl: Get.locale?.languageCode == 'ar',
                  spaceSize: 72,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: TextMarquee(
                  'Doctors'.tr,
                  rtl: Get.locale?.languageCode == 'ar',
                  spaceSize: 72,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: TextMarquee(
                  'My Therapists'.tr,
                  rtl: Get.locale?.languageCode == 'ar',
                  spaceSize: 72,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: TextMarquee(
                  'Profile'.tr,
                  rtl: Get.locale?.languageCode == 'ar',
                  spaceSize: 72,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: TextMarquee(
                  'Settings'.tr,
                  rtl: Get.locale?.languageCode == 'ar',
                  spaceSize: 72,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatBot(), // Assuming ChatBotPage is a widget for the ChatBot content
            Doctors(), // Assuming DoctorsPage is a widget for the Doctors content
            MyTherapists(), // Assuming MyTherapistsPage is a widget for the My Therapists content
            Profile(), // Assuming ProfilePage is a widget for the Profile content
            SettingsPage(), // Add your SettingsPage widget here
          ],
        ),
      ),
    );
  }
}
