import 'package:get/get.dart';
import '../view/screens/settings/setting_controller.dart';
import '../view/screens/settings/theme_controller.dart';
import '../view/widget/drawer.dart';

class GeneralBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(SlideDrawerController());
    Get.lazyPut(() => SettingController());
  }
}
