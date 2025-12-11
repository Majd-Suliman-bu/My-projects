import 'package:get/get.dart';
import 'package:worker_app/view/screens/add_new_drink_stock/add_new_drink_controller.dart';

class AddNewDrinkBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AddNewDrinkController());
  }
}
