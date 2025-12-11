import 'package:get/get.dart';

import '../modules/doctors/doctors_controller.dart';

class DoctorsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DoctorsController>(DoctorsController());
  }
}
