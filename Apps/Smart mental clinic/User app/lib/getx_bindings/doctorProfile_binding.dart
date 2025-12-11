import 'package:get/get.dart';

import '../modules/doctorProfile/doctorProfile_controller.dart';

class DoctorProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DoctorProfileController>(DoctorProfileController());
  }
}
