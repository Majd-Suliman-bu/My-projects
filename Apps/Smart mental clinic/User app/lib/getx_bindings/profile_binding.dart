import 'package:get/get.dart';

import '../modules/profile/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}
