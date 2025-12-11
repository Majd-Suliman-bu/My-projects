import 'package:get/get.dart';
import '../modules/setting/setting_controller.dart';

class SettingBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<SettingController> (SettingController());
  }

}