import 'package:get/get.dart';
import '../modules/myTherapists/myTherapists_controller.dart';

class MyTherapistsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MyTherapistsController>(MyTherapistsController());
  }
}
