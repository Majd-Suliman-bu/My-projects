import 'package:get/get.dart';
import 'package:worker_app/view/screens/settings/theme_controller.dart';

class ThemeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
  }
}
